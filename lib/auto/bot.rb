# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'sequel'

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
  #   @return [Sequel::SQLite::Database] If the database is SQLite (note: all
  #     adapted databases are subclasses of Sequel::Database).
  #   @return [Sequel::MySQL::Database] If the database is MySQL (note: all
  #     adapted databases are subclasses of Sequel::Database).
  #   @return [Sequel::Postgres::Database] If the database is PostgreSQL (note: all
  #     adapted databases are subclasses of Sequel::Database).
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
      
      # Move to ~/.auto if we're a gem.
      @work_dir = nil
      set_directory if Auto.gem?
    end

    # Initialize this instance.
    def init
    
      # Before anything else, start logging.
      puts '* Starting logging...'.bold
      @log = Auto::Logger.new
      @log.info("Logging started at #{Time.now}")

      # Load configuration
      load_config

      # Initialize the central event system
      puts '* Starting the central event system...'.bold
      @log.info("Starting the central event system...")
      @events = Auto::API::Events.new

      # Start the timer system.
      puts '* Starting the timer system...'.bold
      @log.info("Starting the timer system...")
      @clock = Auto::API::Timers.new

      # Prepare for sockets.
      @sockets = []

      # Initialize the database
      load_database

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

    # Produce an error message.
    #
    # @param [String] msg The message.
    # @param [true, false] fatal Whether this error is fatal (will kill the program).
    # @param [Array<String>] bt Backtrace.
    def error msg, fatal = false, bt = nil
      # Print it to STDERR.
      STDERR.puts "ERROR: #{msg}".red
      unless bt.nil?
        STDERR.puts "Backtrace:"
        STDERR.puts bt
      end

      # Log it.
      @log.error(msg)

      if fatal
        #@netloop.kill if @netloop.active
        exit 1
      end
    end

    # Produce a warning message.
    #
    # @param [String] msg The message.
    def warn msg
      @log.warning(msg)

      puts "Warning: #{msg}".red
    end

    # Produce information.
    #
    # @param [String] msg The message.
    def info msg
      @log.info(msg)
      puts "*** #{msg}".green
    end

    # Produce a message for foreground mode.
    #
    # @param [String] msg The message.
    # @param [true, false] log Whether to log it as well as print to STDOUT.
    #
    # @deprecated {#verbose}
    def foreground msg, log = true
      if @opts.foreground?
        puts "[F] #{msg}"
        @log.info("[F] #{msg}") if log
      else
        if @opts.debug?
          debug(msg, log)
        end
      end
    end

    # Produce a debug message.
    #
    # @param [String] msg The message.
    # @param [true, false] log Whether to log it as well as print to STDOUT.
    #
    # @deprecated {#verbose}
    def debug msg, log = false
      if @opts.debug?
        puts "[D] #{msg}".blue
        @log.debug(msg) if log
      end
    end

    # Yield a message of verbosity magic. This will execute any block it is
    # passed.
    #
    # @param [String] message The message to be reported.
    # @param [Integer] level The level of verbosity. We recommend +VSIMPLE+,
    #   +VUSEFUL+, or +VNOISY+.
    def verbose message, level = VNOISY, log = true
      if $VERBOSITY >= level
        puts "==> #{msg}".magenta
        @log.debug(msg) if log
      end

      yield if block_given?
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

    # Move to the ~/.config working directory.
    def set_directory
      Dir.mkdir File.join(Dir.home, '.auto') if !Dir.exists? File.join(Dir.home, '.auto')
      Dir.chdir File.join(Dir.home, '.auto')
      @work_dir = File.join(Dir.home, '.auto')
    end

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
      @log.info("Reading the configuration file #{confpath}...")
      @conf = Auto::Config.new File.expand_path(confpath)

    end

    # Load Auto libraries.
    def load_libraries
      
      puts '* Loading core libraries..'.bold
      @log.info("Loading core libraries...")
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

    # Load database.
    def load_database

      puts '* Initializing database...'.bold
      @log.info('Initializing database...')
      @db = nil

      @db = case @conf['database']['type'] # check the database type in the config
            when 'sqlite' # it's SQLite
              database_sqlite
            when 'mysql', 'postgres' # MySQL and Postgres
              database_sqld
            else
              raise DatabaseError, "Unrecognized database type: #{@conf['database']['type']}"
            end
    end

    # Load database as SQLite.
    #
    # @return [Sequel::SQLite::Database] The database object.
    def database_sqlite
      name = @conf['database']['name'] || 'auto.db'
      Sequel.sqlite(name)
    end

    # Load database as MySQL or Postgres.
    #
    # @return [Sequel::Database] The database object.
    def database_sqld
      %[username password hostname name].each do |d|
        unless @conf['database'].include? d
          raise DatabaseError, "Insufficient configuration. For MySQL and PostgreSQL, we need the username, password, hostname, and name directives."
        end
      end

      adapter = @conf['database']['type'].to_sym

      Sequel.connect(adapter:  adapter, 
                     host:     @conf['database']['hostname'],
                     database: @conf['database']['name'],
                     user:     @conf['database']['username'],
                     password: @conf['database']['passname'])
    end

  end # class Bot
  
end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
