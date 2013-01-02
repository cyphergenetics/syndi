# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require(File.join(File.expand_path(File.dirname(__FILE__)), 'helper.rb'))

require 'auto/api/events'

describe "The API event system" do

  before do
    @events = Auto::API::Events.new
  end

  it 'should return identification data after creating a new event with on()' do
    @events.on('fooBar') { nil }.class.should.equal Array
  end

  it 'should return sufficient identification data' do
    @events.on('meowCat') { nil }.length.should.equal 3
  end

  it 'should trigger all hooks of an event when said event is called' do
    $m.should.receive(:debug)
    @ok = false
    @events.on('bunnyEvent') { @ok = true }
    @events.call('bunnyEvent')
    @events.threads.each { |thr| thr.join }
    @ok.should.be.true
  end

  it 'should trigger events in the order of highest to lowest priority' do
    $m.should.receive(:debug)
    @order = ''
    @events.on('kittenEvent', 5) { @order << 'C' }
    @events.on('kittenEvent', 1) { @order << 'A' }
    @events.on('kittenEvent', 3) { @order << 'B' }
    @events.call('kittenEvent')
    @events.threads.each { |thr| thr.join }
    @order.should.equal 'ABC'
  end

  it 'should permit hooks of higher priority to block subsequent hook executions' do
    $m.should.receive(:debug)
    @good = true
    @events.on('dragonEvent', 1) { false }
    @events.on('dragonEvent', 3) { @good = false }
    @events.call('dragonEvent')
    @events.threads.each { |thr| thr.join }
    @good.should.be.true
  end

  it 'should delete an event given its identification data' do
    @deleted = true
    id = @events.on('unicornEvent') { @deleted = false }
    @events.del(id)
    @events.call('unicornEvent')
    @deleted.should.be.true
  end

end

# vim: set ts=4 sts=2 sw=2 et:
