# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/rubyext/string'
require 'syndi/version'

require 'term/ansicolor'

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

    @config_path = File.join dir, 'config.yml'
    conf

    daemonize if opts.foreground? && $VERBOSITY < 1
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

end

require 'csyndi'
%w[events actress config].each { |lib| require "syndi/#{lib}" }

Syndi.colorize

# vim: set ts=4 sts=2 sw=2 et:
