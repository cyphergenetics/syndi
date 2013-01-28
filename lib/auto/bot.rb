# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

autoload :Redis,  'redis'
autoload :FileKV, 'filekv'

require 'auto/config'
require 'auto/api'

# Namespace: Auto
module Auto

  # This is the central class of Auto, providing all core functionality.
  #
  # It should be additionally noted that for each loaded core library, a readable
  # instance attribute of the library's name will exist, typically pointing to
  # an instance of its respective Library class. (e.g. @irc = <Auto::IRC::Library>)
  #
  # @!attribute [r] opts
  #   @return [Slop] The options object.
  #
  #
  # @!attribute [r] log
  #   @return [Auto::Logger] The logging instance.
  #
  # @!attribute [r] conf
  #   @return [Auto::Config] The configuration instance.
  #
  # @!attribute [r] events
  #   @return [Auto::API::Events] The event system instance.
  #
  # @!attribute [r] clock
  #   @return [Auto::API::Timers] The timer system instance.
  #
  # @!attribute [r] db
  #   @return [Redis] The Redis database.
  #
  # @!attribute [r] libs
  #   @return [Array<String>] List of loaded core libraries.
  #
  # @!attribute [r] netloop
  #   @return [Thread] The thread in which #main_loop is running.
  #
  # @!attribute [r] sockets
  #   @return [Array<Object>] A list of socket objects.
  #
  # @!attribute [r] work_dir
  #   @return [String] The Auto working directory (usually ~/.auto).
  #   @return [nil] If no particular directory has been specified. . . .
  class Bot

    attr_reader :opts, :log, :conf, :events, :clock, :db, :libs,
                :netloop, :sockets, :work_dir

    # Create a new instance of Auto.
    #
    # @param [Hash{String => Object}] opts A hash of options.
    def initialize opts
      # Save options.
      @opts = opts
    end      

    # Initialize this instance.
    def init
    
      # Load configuration
      load_config

      # Initialize the central event system
      puts '* Starting the central event system...'.bold
      $log.info("Starting the central event system...")
      @events = Auto::API::Events.new

      # Start the timer system.
      puts '* Starting the timer system...'.bold
      $log.info("Starting the timer system...")
      @clock = Auto::API::Timers.new

      # Prepare for sockets.
      @sockets = []

      # Initialize the database
      @db = nil
      @db = load_database unless @conf['database']['disable']

      # Load core libraries.
      load_libraries

      true
    end

    # Start the bot.
    def start
      
      # Call the start event.
      @events.call :start

      # Throw the program into the main loop.
      @events.threads.each { |thr| thr.join } # block until we're ready to go
      verbose("Producing a thread and entering the main loop...", VUSEFUL) do
        @netloop = Thread.new { main_loop }
        @netloop.join
      end

    end

    # Daemonize the bot.
    def daemonize
      $log.info "Forking into the background. . . ."
  
      # Direct all incoming data on STDIN and outgoing data on STDOUT/STDERR to /dev/null.
      $stdin  =           File.open '/dev/null'
      $stdout = $stderr = File.open '/dev/null', 'w'
      
      # Fork and retrieve the PID.
      pid = fork

      # Save it to auto.pid.
      unless pid.nil?
        File.open('auto.pid', 'w') { |io| io.puts pid }
        exit 0
      end
    end

    # Main loop.
    def main_loop
      loop do
        # Build a list of sockets.
        sockets       = []
        assoc_objects = {}
        @sockets.each do |o|
          unless o.socket.nil? or o.socket.closed?
            sockets << o.socket
            assoc_objects[o.socket] = o
          end
        end
        next if sockets.empty?

        # Call #select.
        ready_read, _, _ = IO.select(sockets, [], [], nil)

        # Iterate through sockets ready for reading.
        ready_read.each do |socket|
          @events.call :net_receive, assoc_objects[socket]
        end
      end
    end

    # Terminate the bot.
    #
    # @param [String] reason The reason for termination.
    def terminate reason = 'Terminating'
      info "Auto is terminating owing to thus: #{reason}"

      # Call :die
      @events.call :die, reason
    
      # Close the database.
      @db.disconnect

      # When dying, allow about three seconds for hooks to execute before
      # fully terminating.
      sleep 3

      # Delete auto.pid
      File.delete 'auto.pid' unless @opts.foreground?

      exit 0
    end

    #######
    private
    #######

    # Load the configuration.
    def load_config

      # Try to find the file
      # if we're a gem, we'll try ~/.auto/auto.yml
      # else we'll try ./conf/auto.yml
      confpath = nil
      if Auto.gem?
        confpath = File.join(Dir.home, '.auto', 'auto.yml')
      else
        confpath = File.join('conf', 'auto.yml')
      end
      confpath = @opts[:conf] if @opts.conf? # --conf=FILE has supreme precedence

      # Process it.
      puts "* Reading the configuration file #{confpath}...".bold
      $log.info("Reading the configuration file #{confpath}...")
      @conf = Auto::Config.new File.expand_path(confpath)

    end

    # Load Auto libraries.
    def load_libraries
      
      puts '* Loading core libraries..'.bold
      $log.info("Loading core libraries...")
      @libs = []

      # Iterate through each configured library.
      @conf['libraries'].each do |lib|
        lib.dc!

        if @libs.include? lib
          # Don't load a library more than once!
          error("Cannot load library twice (#{lib})! Please fix your configuration.")
          next
        end

        begin
          load_library lib
          @libs.push lib
        rescue => e
          error "Failed to load core library '#{lib}': #{e}", true, e.backtrace
        end

      end

    end

    # Load a core library.
    def load_library lib
      # here is where magic occurs to load a library
      require "auto/#{lib}"
      instance_variable_set "@#{lib}".to_sym, Object.const_get("LIBRARY_#{lib.uc}")
      define_singleton_method(lib.to_sym) { self.instance_variable_get("@#{__method__}".to_sym) }
    end

    # Load the Redis database.
    def load_database
      
      $log.info 'Initializing database...'

      driver = @conf['database']['driver'] || 'redis'

      case driver
      when 'redis'
        load_db_redis
      when 'flatfile'
        load_db_flatfile
      end

    end

    # Initializes Redis.
    def load_db_redis

      config = Hash.new
      if host = @conf['database']['address']
        config[:host] = host
      end
      if port = @conf['database']['port']
        config[:port] = port
      end
      if path = @conf['database']['path']
        config[:path] = path
      end

      redis = Redis.new config

      if passwd = @conf['database']['password']
        redis.auth passwd
      end
      if id = @conf['database']['number']
        redis.select id
      end

      redis

    end

    # Initializes Flatfile.
    def load_db_flatfile
      FileKV.new 'auto.db'
    end

  end # class Bot
  
end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
