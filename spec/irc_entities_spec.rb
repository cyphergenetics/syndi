# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require(File.join(File.expand_path(File.dirname(__FILE__)), 'helper.rb'))

require 'auto/irc/object/entity'

describe "IRC entities" do

  before do
    @ircmock = mock("A mock of Auto::IRC::Server", :nick => 'unicorn', :user => 'nyan', :mask => 'alyx.is.a.goose.autoproj.org')
    @ent     = Auto::IRC::Object::Entity.new(@ircmock, :channel)
  end

  it 'should respond to #channel?' do
  end

  it 'should respond to #user?' do
  end

  it 'should have a readable Auto::IRC::Server object' do
  end

  it 'should send a msg on #msg' do
  end

  it 'should divide messages which are too long' do
  end

end

# vim: set ts=4 sts=2 sw=2 et:
