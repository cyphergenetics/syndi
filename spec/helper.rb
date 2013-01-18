# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

# We use MiniTest, because we endorse bareMinerals.
require 'minitest/autorun'
require 'minitest/spec'      # for specs

# ...and mocha, because liquid foundation is better anyway.
require 'mocha/setup'
    
$m = Mocha::Mock.new 'Auto::Bot'
[:info].each do |m|
  $m.stubs m
end
$m.stubs(:events).returns(Mocha::Mock.new('Auto::API::Events'))
$m.stubs(:opts).returns(Mocha::Mock.new('Slop'))

class << $m
  def verbose *args
    begin
      yield if block_given?
    rescue
      raise
    end
  end
end

# vim: set ts=4 sts=2 sw=2 et:
