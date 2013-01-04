# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require(File.join(File.expand_path(File.dirname(__FILE__)), 'helper.rb'))

require 'auto/irc/object/entity'

describe "IRC entities" do

  before do
    @ircmock  = mock("A mock of Auto::IRC::Server", :nick => 'unicorn', :user => 'nyan', :mask => 'alyx.is.a.goose.autoproj.org')
    @ent      = Auto::IRC::Object::Entity.new(@ircmock, :channel, 'jonathantaylor')
  end

  it 'should respond to #channel?' do
    @ent.channel?.should.be.true
  end

  it 'should respond to #user?' do
    @ent.user?.should.be.false
  end

  it 'should have a readable Auto::IRC::Server object' do
    @ent.irc.class.should.equal Facon::Mock # technically this isn't Auto::IRC::Server but... Elizacat is a cart
  end

  it 'should send a msg on #msg' do
    @ircmock.should.receive(:snd).with('PRIVMSG jonathantaylor :le Oshawott')
    $m.should.receive(:events).times 2
    $m.events.should.receive(:call).with('irc:onMsg', @ent, 'le Oshawott')
    @ent.msg 'le Oshawott'
  end

  it 'should divide messages which are too long' do
    @ircmock.should.receive(:snd).times 2
    $m.should.receive(:events).times 2
    $m.events.should.receive(:call)
    @ent.msg 'der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt  der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt'
  end

end

# vim: set ts=4 sts=2 sw=2 et:
