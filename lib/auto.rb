# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Class Auto: Main bot class.
class Auto

  attr_reader :opts, :conf, :log, :mods, :sockets, :events, :timers, :irc_parser

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

    # Parse the configuration file, auto.conf.
    puts "* Reading the configuration file conf/auto.conf..."
    @log.info("Reading the configuration file conf/auto.conf...")
    @conf = Parser::Config.new('conf/auto.conf')

    # Start the event system.
    puts "* Starting the event system..."
    @log.info("Starting the event system...")
    @events = API::Events.new

    # Start the timer system.
    puts "* Starting the timer system..."
    @log.info("Starting the timer system...")
    @timers = API::Timers.new

    # Load core modules.
    puts "* Loading core modules..."
    @log.info("Loading core modules...")
    @mods = []
    @conf.get('*', 'module').each do |mod|
      if mod == 'irc'
        begin
          require_relative 'irc/server.rb'
          require_relative 'irc/parser.rb'
          @irc_parser = IRC::Parser.new
          require_relative 'irc/std.rb'
          IRC::Std.init
          @mods << 'irc'
        rescue => e
          error("Unable to load core module `irc`: #{e}", true)
        end
      end
    end

    # Create additional instance variables.
    @sockets = {}
      
    true
  end

  # Start the bot.
  # ()
  def start

    # Check if the irc core module is loaded.
    if @mods.include?('irc')
      # Prepare for incoming data.
      $m.events.on(self, 'Irc.OnReadReady') do |irc|
        until irc.recvq.length == 0
          line = irc.recvq.shift.chomp
          foreground("#{irc} >> #{line}")
          @irc_parser.parse(irc, line)
        end
      end
        
      # Iterate through each IRC server in the config, and connect to them.
      @conf.get('irc').each do |name, block|
        begin
          # Configure the IRC instance.
          @sockets[name] = IRC::Server.new(name) do |c|
            c.address = block['address'][0]
            c.port    = block['port'][0]
            c.nick    = block['nick'][0] 
            c.user    = block['user'][0]
            c.real    = block['real'][0]
            c.ssl     = block['ssl'][0]
          end

          # Connect.
          @sockets[name].connect
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
      @sockets.each do |name, obj|
        unless obj.socket.nil?
          sockets << obj.socket
        end
      end
      
      # Call select().
      ready_read, ready_write, ready_err = IO.select(sockets, [], [], nil)

      # Iterate through sockets ready for reading.
      ready_read.each do |socket|
        name = @sockets.each { |name, tsock| break name if tsock.socket == socket }
        @sockets[name].recv
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
  def debug(msg, log)
    if @opts['debug']
      puts "[D] #{msg}"
      @log.debug(msg) if log
    end
  end

end # class Auto

# vim: set ts=4 sts=2 sw=2 et:
