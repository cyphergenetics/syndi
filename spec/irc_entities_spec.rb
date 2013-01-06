# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require(File.expand_path('../helper.rb', __FILE__))

require 'auto/irc/object/entity'

describe Auto::IRC::Object::Entity do

  before do
    @ircmock  = mock('Auto::IRC::Server')
    @ent      = Auto::IRC::Object::Entity.new(@ircmock, :channel, 'jonathantaylor')
  end

  it '#channel?' do
    @ent.channel?.must_equal true
  end

  it '#user?' do
    @ent.user?.must_equal false
  end

  describe '#msg' do
    before do
      @ircmock.stubs(:nick).returns('unicorn')
      @ircmock.stubs(:user).returns('nyan')
      @ircmock.stubs(:mask).returns('alyx.is.a.goose.autoproj.org')
    end

    it 'should send a message' do
      @ircmock.expects(:snd).with('PRIVMSG jonathantaylor :le Oshawott')
      $m.events.expects(:call).with('irc:onMsg', @ent, 'le Oshawott')
      @ent.msg 'le Oshawott'
    end

    it 'should divide messages which are too long' do
      @ircmock.expects(:snd).times 2
      $m.events.expects(:call)
      @ent.msg 'der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt  der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt der Welt'
    end

    it 'should send a notice if told to' do
      @ircmock.expects(:snd).with('NOTICE jonathantaylor :le Oshawott')
      $m.events.expects(:call).with('irc:onMsg', @ent, 'le Oshawott')
      @ent.msg 'le Oshawott', true
    end
  end

end

# vim: set ts=4 sts=2 sw=2 et:
