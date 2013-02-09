# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/rubyext/string'
require 'syndi/version'
require 'fileutils'

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
    FileUtils.mkdir_p directory unless Dir.exists? directory
    Dir.chdir directory
    @app_dir = directory
  end 

  # Initiate Syndi with command-line +options+.
  #
  # @param [Slop] options The command-line options.
  def go options
    
  end

  # Logger access.
  #
  # @return [Syndi::Logger]
  def log
    @logger ||= Syndi::Logger.new
  end

  # Central event system access.
  #
  # @return [Syndi::Events]
  def events
    @event_manager ||= Syndi::Events.new
  end

  # Configuration access.
  #
  # @return [Syndi::Config]
  def conf
    @configuration ||= Syndi::Config.new
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

end

require 'csyndi'
%w[events actress config bot].each { |lib| require "syndi/#{lib}" }

Syndi.colorize

# vim: set ts=4 sts=2 sw=2 et:
