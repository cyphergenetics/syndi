# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'auto/rubyext/string'
require 'auto/version'

module Auto

  # @return [Boolean] Whether we're installed as a gem.
  def self.gem?
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
  def self.windows?
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
  def self.windows_colored
    colors = [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white]
    extras = [:clear, :bold, :underline, :reversed]
    
    colors.each do |col|
      String.send(:define_method, col, proc { self })
    end
    extras.each do |extr|
      String.send(:define_method, extr, proc { self })
    end
  end

end

if Auto.windows?
  Auto.windows_colored
else
  require 'colored'
end

require 'libauto' # include the native extension
require 'auto/bot'

# vim: set ts=4 sts=2 sw=2 et:
