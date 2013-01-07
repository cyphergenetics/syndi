# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require_relative "helper"

require "auto/api/plugin"
require "auto/version"
require "auto/dsl/base"
require "auto/dsl/irc"

$m.stubs(:opts).returns Mocha::Mock.new('OPTS')
$m.opts.stubs(:verbose?).returns false


describe "The Auto Plugin API" do

  it "uses a block to let you configure it" do
    $m.expects(:debug) 

    class TestPluginConfigure < Auto::API::Plugin; end
    plugin = TestPluginConfigure.new 
    plugin.configure do |c|
      c.name     = "AutumnPrettyCaller"
      c.summary  = "Basically it's just swarley in a plugin"
      c.version  = "1.33.7"
      c.library  = "irc"
      c.author   = "swarley"
      c.auto     = "~> 4.0"
    end
    [plugin.name, plugin.summary, plugin.version, plugin.library, plugin.author, plugin.auto].must_equal(
      ["AutumnPrettyCaller", "Basically it's just swarley in a plugin", "1.33.7", "irc", "swarley", "~> 4.0"]
    )
  end

end
