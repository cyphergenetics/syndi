# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'colored'
require 'sequel'
require 'auto/rubyext/string'

require 'auto/logger'
require 'auto/config'

require 'auto/api'

# Namespace: Auto
module Auto

  VERSIONSPEC  = {
    major:    4,
    minor:    0,
    patch:    0,
    pre:      'a.0.1',
    codename: 'phoenix'
  }.freeze
  VERSION      = "#{VERSIONSPEC[:major]}.#{VERSIONSPEC[:minor]}.#{VERSIONSPEC[:patch]}"
  VERSION.concat '.'+VERSIONSPEC[:pre] if VERSIONSPEC.include? :pre
  VERSION.freeze
  FULLVERSION = "#{VERSION}+#{VERSIONSPEC[:codename]}".freeze

  # This is the central class of Auto, providing all core functionality.
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
  class Bot

    attr_reader :opts, :log, :conf, :events, :clock, :db, :libs, :irc_sockets, :irc_parser,
                :extend, :irc_cmd

    # Create a new instance of Auto.
    #
    # @param [Hash{String => Object}] opts A hash of options.
    def initialize(opts)
      # Save options.
      @opts = opts
    end

    # Initialize this instance.
    def init
    
      # Before anything else, start logging.
      puts '* Starting logging...'.bold
      @log = Auto::Logger.new
      @log.info("Logging started at #{Time.now}")

      ## Load configuration ##

      # Try to find the file
      # conf/ is given precedence over ~/.config/autobot/
      # unless we're installed as a gem, in which case conf/ is ignored
      confpath = nil
      if @opts.json?
        if File.exists? File.join(%w[conf auto.json]) and !Auto.gem?
          confpath = File.join(%w[conf auto.json])
        elsif File.exists? File.join(Dir.home, '.config', 'autobot', 'auto.json')
          confpath = File.join(Dir.home, '.config', 'autobot', 'auto.json')
        end
      else
        if File.exists? File.join(%w[conf auto.yml]) and !Auto.gem?
          confpath = File.join(%w[conf auto.yml])
        elsif File.exists? File.join(Dir.home, '.config', 'autobot', 'auto.yml')
          confpath = File.join(Dir.home, '.config', 'autobot', 'auto.yml')
        end
      end
      confpath = @opts[:conf] if @opts.conf? # --conf=FILE has supreme precedence
      error('Could not find a configuration file', true) if confpath.nil?

      # Process it.
      puts "* Reading the configuration file #{confpath}...".bold
      @log.info("Reading the configuration file #{confpath}...")
      @conf = Auto::Config.new(File.expand_path(confpath))

      # Move to ~/.config/autobot if we're a gem.
      if Auto.gem?
        Dir.mkdir File.join(Dir.home, '.config') if !Dir.exists? File.join(Dir.home, '.config')
        Dir.mkdir File.join(Dir.home, '.config', 'autobot') if !Dir.exists? File.join(Dir.home, '.config', 'autobot')
        Dir.chdir File.join(Dir.home, '.config', 'autobot')
      end

      # Start the event system.
      puts '* Starting the event system...'.bold
      @log.info("Starting the event system...")
      @events = Auto::API::Events.new

      # Start the timer system.
      puts '* Starting the timer system...'.bold
      @log.info("Starting the timer system...")
      @clock = Auto::API::Timers.new

      ## Initialize the database ##
      puts '* Initializing database...'.bold
      @log.info('Initializing database...')
      @db = nil

      case @conf['database']['type'] # check the database type in the config
      
      when 'sqlite' # it's SQLite
        
        if @conf['database'].include? 'name'
          name = @conf['database']['name']
        else
          name = 'auto.db'
        end

        @db = Sequel.sqlite(name)

      when 'mysql', 'postgres'

        %[username password hostname name].each do |d|
          unless @conf['database'].include? d
            raise DatabaseError, "Insufficient configuration. For MySQL and PostgreSQL, we need the username, password, hostname, and name directives."
          end
        end

        if @conf['database']['type'] == 'mysql'
          adapter = :mysql
        else
          adapter = :postgres
        end

        @db = Sequel.connect(:adapter  => adapter, 
                             :host     => @conf['database']['hostname'],
                             :database => @conf['database']['name'],
                             :user     => @conf['database']['username'],
                             :password => @conf['database']['passname'])

      else
        raise DatabaseError, "Unrecognized database type: #{@conf['database']['type']}"
      end

      # Load core libraries.
      puts '* Loading core libraries..'.bold
      @log.info("Loading core libraries...")
      @libs = []
      @conf.x['libraries'].each do |lib|
        if lib == 'irc'

          begin
            path = File.expand_path(File.dirname __FILE__) << "/irc/"
            %w{server parser std commands object/user object/message}.each do |file|
              require (path + file + ".rb")
            end
            @irc_parser = IRC::Parser.new
            IRC::Std.init
            @irc_cmd = IRC::Commands.new
            @irc_sockets = {}
            @libs << 'irc'
          rescue => e
            error "Unable to iload core library `irc`: #{e}", true, e.backtrace
          end
        end
      end

      # Load plugins.
      # @todo Plugin loading needs improvement.
      #puts "* Loading plugins..."
      #@log.info("Loading plugins...")
      #@extend = API::Extender.new
      #if @conf.x.include? 'plugins'
      #  @conf.x['plugins'].each do |plugin|
      #    @extend.pload(plugin)
      #  end
      #end

      true
    end

    # Start the bot.
    def start

      # Check if the irc core library is loaded.
      if @libs.include?('irc')
        # Prepare for incoming data.
        $m.events.on(self, 'irc:onReadReady') do |irc|
          until irc.recvq.length == 0
            line = irc.recvq.shift.chomp
            foreground("#{irc} >> #{line}")
            @irc_parser.parse(irc, line)
          end
        end
        
        # Iterate through each IRC server in the config, and connect to them.
        @conf.x['irc'].each do |name, hash|
          begin
            # Configure the IRC instance.
            @irc_sockets[name] = IRC::Server.new(name) do |c|
              c.address = hash['address']
              c.port    = hash['port']
              c.nick    = hash['nickname'][0] 
              c.user    = hash['username']
              c.real    = hash['realName']
              c.ssl     = hash['useSSL']
            end

            # Connect.
            @irc_sockets[name].connect
          rescue => e
            error("Connection to #{name} failed: #{e}", false, e.backtrace)
          end
        end
      end

      # Throw the program into the main loop.
      debug("Producing a thread and entering the main loop...")
      @netloop = Thread.new { main_loop }
      @netloop.join

    end

    # Main loop.
    def main_loop

      loop do
      
        # Build a list of sockets.
        sockets = []
        @irc_sockets.each do |name, obj|
          unless obj.socket.nil?
            sockets << obj.socket
          end
        end
      
        # Call #select.
        ready_read, ready_write, ready_err = IO.select(sockets, [], [], nil)

        # Iterate through sockets ready for reading.
        ready_read.each do |socket|
          name = @irc_sockets.each { |name, tsock| break name if tsock.socket == socket }
          @irc_sockets[name].recv
        end

      end

    end

    # Produce an error message.
    #
    # @param [String] msg The message.
    # @param [true, false] fatal Whether this error is fatal (will kill the program).
    # @param [Array<String>] bt Backtrace.
    def error(msg, fatal=false, bt=nil)
      # Print it to STDERR.
      STDERR.puts "ERROR: #{msg}".red
      unless bt.nil?
        STDERR.puts "Backtrace:"
        STDERR.puts bt
      end

      # Log it.
      @log.error(msg)

      @netloop.die and exit 1 if fatal
    end

    # Produce a warning message.
    #
    # @param [String] msg The message.
    def warn(msg)
      # Log it.
      @log.warning(msg)

      # Foreground it.
      foreground("Warning: #{msg}".red, false)
    end

    # Produce information.
    #
    # @param [String] msg The message.
    def info(msg)
      @log.info(msg)
      foreground(">>> #{msg}".green, false)
    end

    # Produce a message for foreground mode.
    #
    # @param [String] msg The message.
    # @param [true, false] log Whether to log it as well as print to STDOUT.
    def foreground(msg, log=true)
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
    def debug(msg, log=false)
      if @opts.debug?
        puts "[D] #{msg}".blue
        @log.debug(msg) if log
      end
    end

    # Terminate the bot.
    #
    # @param [String] reason The reason for termination.
    def terminate(reason='Terminating')
      info("Auto is terminating owing to thus: #{reason}")

      # Call bot:onTerminate
      $m.events.call('bot:onTerminate')
    
      # Disconnect from IRC networks if IRC is in use.
      if @libs.include? 'irc'
        @irc_sockets.each { |name, obj| obj.disconnect(reason) }
      end

      # Close the database.
      @db.close

      # Delete auto.pid
      unless @opts.debug? or @opts.foreground?
        File.delete('auto.pid')
      end

      exit 0
    end

  end # class Bot
  
  # Whether we're installed as a gem.
  #
  # @return [true, false]
  def self.gem? 
    res = File.expand_path(__FILE__) =~ /^#{Regexp.escape File.join(Dir.home, '.gem')}/
    res.nil? ? false : true
  end

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
