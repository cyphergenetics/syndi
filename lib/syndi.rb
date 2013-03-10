# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/rubyext/string'
require 'syndi/version'

require 'term/ansicolor'
require 'redis'

module Syndi
  extend self

  # @return [Boolean] Whether we're installed as a gem.
  def gem?
    begin
      # If we already checked, just return the result of that.
      return @gem if defined? @gem

      # Otherwise, check.
      result = Gem.path.each do |gempath|
        break true if __FILE__ =~ /^#{Regexp.escape gempath}/
      end
      @gem = (result == true ? true : false)
    ensure
      @gem ||= false
    end
  end

  # @return [Boolean] Whether we're running on Microsoft Windows.
  def windows?
    begin
      return @windows if defined? @windows
      if ::RbConfig::CONFIG['host_os'] =~ /bccwin|djgpp|mswin|mingw|cygwin|wince/i
        @windows = true
      else
        @windows = false
      end
    ensure
      @windows ||= false
    end
  end

  # Install terminal colors.
  def colorize
    if windows?
      Term::ANSIColor.attributes.each do |name|
        String.send :define_method, name, proc { self }
      end
    else
      String.send :include, Term::ANSIColor
    end
  end

  ###################
  # central methods #
  ###################

  # Retrieve the application data directory.
  #
  # @return [String]
  def dir
    @app_dir ||= File.join ENV['HOME'], '.syndi'
  end

  # Set the application data directory.
  def dir= directory
    Dir.mkdir directory unless Dir.exists? directory
    Dir.chdir directory
    @app_dir = directory
  end 

  # Initiate Syndi with command-line `options`.
  #
  # @param [Slop] options The command-line options.
  def boot options
    puts "* Syndi #{Syndi::VERSION} starting...".bold
    @options = options

    # Load the configuration file.
    @config_path = File.join dir, 'config.yml'
    conf

    # And our libraries.
    load_libraries

    # And the Redis database.
    @database = load_database

    # Now daemonize.
    daemonize if opts.foreground? && $VERBOSITY < 1
    @start_time = Time.now
    
    log.info "Syndi successfully started at #@start_time!"

    events.emit :start
  end

  # Time of starting.
  def start_time
    @start_time
  end

  # Logger access.
  #
  # @return [Syndi::Logger]
  def log
    @logger ||= Syndi::Logger.new
  end

  # Make Celluloid logging consistent with Syndi logging.
  def celluloid_log
    Celluloid.logger = self.log
  end

  # Central event system access.
  #
  # @return [Syndi::Events]
  def events
    @event_manager ||= Syndi::Events.new
  end

  # Access to command-line options.
  #
  # @return [Slop]
  def opts
    @options
  end

  # Configuration access.
  #
  # @return [Syndi::Config]
  def conf
    @configuration ||= Syndi::Config.new @config_path
  end

  # Central Syndi Celluloid actor.
  #
  # @return [Syndi::Actress] Subclass of {Celluloid::Actor}.
  def actress
    @actress ||= Syndi::Actress.new
  end

  # Access a list of Syndi libraries.
  # @return [Array<String>]
  def libs
    @libs
  end

  # Access the database.
  # @return [Redis]
  def db
    @database
  end

  # Execute some code after the given interval.
  #
  # @param [Integer] interval
  #
  # @return [Celluloid::Timer]
  def after interval, &prc
    actress.after interval, &prc
  end
  
  # Execute some code every +interval+.
  #
  # @param [Integer] interval
  #
  # @return [Celluloid::Timer]
  def every interval, &prc
    actress.every interval, &prc
  end
    
  # Terminate the bot.
  #
  # @param [String] reason The reason for termination.
  def terminate reason = 'Terminating'
    log.info "Syndi is terminating owing to thus: #{reason}"

    # Call :die
    events.emit :die, reason
    
    # Close the database.
    @db.disconnect

    # When dying, allow about three seconds for hooks to execute before
    # fully terminating.
    sleep 3

    # Delete syndi.pid
    File.delete File.join(dir, 'syndi.pid') if File.exists File.join(dir, 'syndi.pid')

    exit
  end

  ###################
  # utility methods #
  ###################

  def daemonize
    log.info "Forking into the background. . . ."
  
    # Direct all incoming data on STDIN and outgoing data on STDOUT/STDERR to /dev/null.
    $stdin  =           File.open '/dev/null'
    $stdout = $stderr = File.open '/dev/null', 'w'
      
    # Fork and retrieve the PID.
    pid = fork

    # Save it to syndi.pid.
    unless pid.nil?
      File.open(File.join(dir, 'syndi.pid'),'w') { |io| io.puts pid }
      exit
    end
  end

  def trap_signals
    Signal.trap('TERM') { Syndi.terminate 'Caught termination signal' }
    Signal.trap('INT') { Syndi.terminate 'Ctrl-C pressed' }
    Signal.trap('HUP') { Syndi.conf.rehash } unless File::ALT_SEPARATOR
  end
    
  # Load a core library.
  # @param [String] lib The library to be loaded, which should exist under the `syndi/` namespace.
  def load_library lib
    load "syndi/#{lib}"

    instance_variable_set "@#{lib}".to_sym, Object.const_get("LIBRARY_#{lib.uc}")
    Object.send :remove_const, "LIBRARY_#{lib.uc}"
    define_singleton_method(lib.to_sym) { self.instance_variable_get("@#{__method__}".to_sym) }
  end
    
  # Load Syndi libraries.
  def load_libraries
      
    log.info 'Loading core libraries...'
    @libs = []

    # Iterate through each configured library.
    conf['libraries'].each do |lib|
      lib.dc!

      if @libs.include? lib
        # Don't load a library more than once!
        log.error "Cannot load library twice (#{lib})! Please fix your configuration."
        next
      end

      begin
        load_library lib
        @libs.push lib
      rescue => e
        log.error "Failed to load core library '#{lib}': #{e}", true
      end

    end

  end
    
  # Initializes Redis.
  def load_database

    config = Hash.new
    %i[address port path].each { |opt| config[opt] = @conf['database'][opt.to_s] if @conf['database'][opt.to_s] }

    redis = Redis.new config

    if passwd = @conf['database']['password']
      redis.auth passwd
    end
    if id = @conf['database']['number']
      redis.select id
    end

    redis

  end

end

require 'csyndi'
%w[events actress config].each { |lib| require "syndi/#{lib}" }

Syndi.colorize

# vim: set ts=4 sts=2 sw=2 et:
