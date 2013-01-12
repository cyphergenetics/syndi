# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'auto/rubyext/string'
require 'auto/version'
require 'libauto' # include the native extension
require 'auto/bot'

module Auto

  # @return [Boolean] Whether we're installed as a gem.
  def self.gem?
    begin
      return @gem if defined? @gem
      if File.expand_path(__FILE__) =~ /^#{Regexp.escape File.join(Dir.home, '.gem')}/
        @gem = true
      else
        @gem = false
      end
    ensure
      @gem ||= false
    end
  end

  # @return [Boolean] Whether we're running on Microsoft Windows.
  def self.windows?
    begin
      return @windows if defined? @windows
      if ::RbConfig::CONFIG['host_os'] =~ /win32|mingw|cygwin/
        @windows = true
      else
        @windows = false
      end
    ensure
      @windows ||= false
    end
  end

end

# vim: set ts=4 sts=2 sw=2 et:
