# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'colored'
require 'sequel'

require 'auto/logger'
require 'auto/config'

require 'auto/api'

# Namespace: Auto
module Auto

  VERSION = '4.0.0d'

  # This is the central class of Auto, providing all core functionality.
  #
  # @!attribute [r] opts
  #   @return [Hash{String => Object}] The options hash.
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
      confpath = @opts['altconf'] || File.join(%w[conf auto.yml])
      if @opts['json']
        confpath = File.join(%w[conf auto.json]) unless @opts.include? 'altconf'
      end

      # Process it.
      puts "* Reading the configuration file #{confpath}...".bold
      @log.info("Reading the configuration file #{confpath}...")
      @conf = Auto::Config.new(File.expand_path(confpath))

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
          adapter = :pgsql
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
            @libs << 'irc'
          rescue => e
            error "Unable to load core library `irc`: #{e}", true, e.backtrace
          end
        end
      end

    # Load plugins.
    puts "* Loading plugins..."
    @log.info("Loading plugins...")
    @extend = API::Extender.new
    if @conf.x.include? 'plugins'
      @conf.x['plugins'].each do |plugin|
        @extend.pload(plugin)
      end
    end

    # Create additional instance variables.
    @irc_sockets = {}
      
    true
  end

  # Start the bot.
  # ()
  def start

    # Check if the irc core module is loaded.
    if @mods.include?('irc')
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
    main_loop()

  end

  # Main loop.
  # ()
  def main_loop

    loop do
      
      # Build a list of sockets.
      sockets = []
      @irc_sockets.each do |name, obj|
        unless obj.socket.nil?
          sockets << obj.socket
        end
      end
      
      # Call select().
      ready_read, ready_write, ready_err = IO.select(sockets, [], [], nil)

      # Iterate through sockets ready for reading.
      ready_read.each do |socket|
        name = @irc_sockets.each { |name, tsock| break name if tsock.socket == socket }
        @irc_sockets[name].recv
      end

    end

  end

  # Produce an error message.
  # (str, [bool], [str])
  def error(msg, fatal=false, bt=nil)
    # Print it to STDERR.
    STDERR.puts "ERROR: #{msg}"
    if !bt.nil?
      STDERR.puts "Backtrace:"
      STDERR.puts bt
    end

    # Log it.
    @log.error(msg)

    exit 1 if fatal
  end

  # Produce a warning message.
  # (str)
  def warn(msg)
    # Log it.
    @log.warning(msg)

    # Foreground it.
    foreground(msg, false)
  end

  # Produce information.
  # (str)
  def info(msg)
    @log.info(msg)
    foreground(msg, false)
  end

  # Produce a message for foreground mode.
  # (str, [bool])
  def foreground(msg, log=true)
    if @opts['foreground']
      puts "[F] #{msg}"
      @log.info("[F] #{msg}") if log
    else
      if @opts['debug']
        debug(msg, log)
      end
    end
  end

  # Produce a debug message.
  def debug(msg, log=false)
    if @opts['debug']
      puts "[D] #{msg}"
      @log.debug(msg) if log
    end
  end

  # Terminate the bot.
  def terminate(reason='Terminating')
    info("Auto is terminating owing to thus: #{reason}")

    # Call bot:onTerminate
    $m.events.call('bot:onTerminate')
    
    # Disconnect from IRC networks if IRC is in use.
    if @mods.include? 'irc'
      @irc_sockets.each { |name, obj| obj.disconnect(reason) }
    end

    # Close the database.
    @db.close

    # Delete auto.pid
    unless @opts['debug'] or @opts['foreground']
      File.delete('auto.pid')
    end

    exit 0
  end

  end # class Bot

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
