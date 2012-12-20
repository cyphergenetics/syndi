# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Class Auto: Main bot class.
class Auto

  attr_reader :opts, :conf, :log, :mods, :irc_sockets, :events, :timers, :irc_parser,
              :extend, :db, :irc_cmd

  # Create a new instance of Auto.
  # (hash)
  def initialize(opts)
    # Save options.
    @opts = opts
  end

  # Initialize Auto.
  # ()
  def init
    
    # Before anything else, start logging.
    puts "* Starting logging..."
    @log = Core::Logging.new
    @log.info("Logging started")

    ## Load configuration ##

    # Foremost, check for an alternate file.
    confpath = 'conf/auto.json'
    if @opts.include?('altconf')
      confpath = @opts['altconf']
    end

    # Process it.
    puts "* Reading the configuration file #{confpath}..."
    @log.info("Reading the configuration file #{confpath}...")
    @conf = Core::Config.new(confpath)

    # Start the event system.
    puts "* Starting the event system..."
    @log.info("Starting the event system...")
    @events = API::Events.new

    # Start the timer system.
    puts "* Starting the timer system..."
    @log.info("Starting the timer system...")
    @timers = API::Timers.new

    # Open the database.
    @db = SQLite3::Database.new 'auto.db'

    # Load core modules.
    puts "* Loading core modules..."
    @log.info("Loading core modules...")
    @mods = []
    @conf.x['modules'].each do |mod|
      if mod == 'irc'
        begin
          require_relative 'irc/server.rb'
          require_relative 'irc/parser.rb'
          @irc_parser = IRC::Parser.new
          require_relative 'irc/std.rb'
          IRC::Std.init
          require_relative 'irc/commands.rb'
          require_relative 'irc/object/user.rb'
          @irc_cmd = IRC::Commands.new
          @mods << 'irc'
        rescue => e
          error "Unable to load core module `irc`: #{e}", true
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
      

end # class Auto

# vim: set ts=4 sts=2 sw=2 et:
