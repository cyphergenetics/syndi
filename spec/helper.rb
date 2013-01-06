# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

# We use MiniTest, because we endorse bareMinerals.
require 'minitest/autorun'
require 'minitest/spec'      # for specs

# ...and mocha, because liquid foundation is better anyway.
require 'mocha/setup'
    
$m = Mocha::Mock.new 'Auto::Bot'
[:debug, :foreground, :info].each do |m|
  $m.stubs m
end

# vim: set ts=4 sts=2 sw=2 et:
