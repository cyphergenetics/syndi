# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'auto/rubyext/string'
require 'auto/version'

module Auto
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

  # This fixes coloring issues on Windows--or at least, the ones with which we
  # need be concerned.
  def windows_colored
    colors = [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white]
    extras = [:clear, :bold, :underline, :reversed]
    
    colors.each do |col|
      String.send(:define_method, col, proc { self })
    end
    extras.each do |extr|
      String.send(:define_method, extr, proc { self })
    end
  end

  ###################
  # central methods #
  ###################

  # Retrieve the application data directory.
  #
  # @return [String]
  def dir
    @app_dir ||= File.join ENV['HOME'], '.auto'
  end

  # Initiate Auto with command-line +options+.
  #
  # @param [Slop] options The command-line options.
  def go options
    
  end

  # Logger access.
  #
  # @return [Auto::Logger]
  def log
    @logger ||= Auto::Logger.new
  end

  # Central event system access.
  #
  # @return [Auto::Events]
  def events
    @event_manager ||= Auto::Events.new
  end

  # Configuration access.
  #
  # @return [Auto::Config]
  def conf
    @configuration ||= Auto::Config.new
  end

  # Central Auto Celluloid actor.
  #
  # @return [Auto::Actress] Subclass of {Celluloid::Actor}.
  def actress
    @actress ||= Auto::Actress.new
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

if Auto.windows?
  Auto.windows_colored
else
  require 'colored'
end

require 'libauto'
%w[events actress config bot].each { |lib| require "auto/#{lib}" }

# vim: set ts=4 sts=2 sw=2 et:
