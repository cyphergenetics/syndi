# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.
require 'bacon'
require 'spec/test_helpers'

require 'auto/api/events'

describe "The API event system" do

  before do
    @events = Auto::API::Events.new
  end

  it 'should return identification data after creating a new event with on()' do
    @events.on(self, 'fooBar') { nil }.class.should.equal Array
  end

  it 'should return sufficient identification data' do
    @events.on(self, 'meowCat') { nil }.length.should.equal 4
  end

  it 'should trigger all hooks of an event when said event is called' do
    @ok = false
    @events.on(self, 'bunnyEvent') { @ok = true }
    @events.call('bunnyEvent')
    @ok.should.be.true
  end

  it 'should trigger events in the order of highest to lowest priority' do
    @order = ''
    @events.on(self, 'kittenEvent', 5) { @order << 'C' }
    @events.on(self, 'kittenEvent', 1) { @order << 'A' }
    @events.on(self, 'kittenEvent', 3) { @order << 'B' }
    @events.call('kittenEvent')
    @order.should.equal 'ABC'
  end

  it 'should delete an event given its identification data' do
    @deleted = true
    id = @events.on(self, 'unicornEvent') { @deleted = false }
    @events.del(id)
    @events.call('unicornEvent')
    @deleted.should.be.true
  end

end

# vim: set ts=4 sts=2 sw=2 et:
