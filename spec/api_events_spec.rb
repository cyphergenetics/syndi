# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require(File.expand_path('../helper.rb', __FILE__))

require 'auto/api/events'

describe 'Auto::API::Events' do

  before do
    @events = Auto::API::Events.new
  end

  describe '#on' do
    it 'should return identification data' do
      @events.on(:foo_bar) { nil }.must_be_instance_of Array
    end
    it 'should return sufficient identification data' do
      @events.on(:meow_cat) { nil }.length.must_equal 3
    end
  end

  describe '#call' do
    before do
      $m.opts.expects(:verbose?)
    end

    it 'should call all hooks of given event' do
      @ok = false
      @events.on('bunnyEvent') { @ok = true }
      @events.call('bunnyEvent')
      @events.threads.each { |thr| thr.join }
      @ok.must_equal true
    end

    it 'should call hooks in descending priority' do
      @order = ''
      @events.on(:kitten_event, 5) { @order << 'C' }
      @events.on(:kitten_event, 1) { @order << 'A' }
      @events.on(:kitten_event, 3) { @order << 'B' }
      @events.call(:kitten_event)
      @events.threads.each { |thr| thr.join }
      @order.must_equal 'ABC'
    end

    it 'should suspend execution if false is received' do
      @good = true
      @events.on(:dragon_event, 1) { false }
      @events.on(:dragon_event, 3) { @good = false }
      @events.call(:dragon_event)
      @events.threads.each { |thr| thr.join }
      @good.must_equal true
    end
  end

  describe '#del' do
    it 'should delete an event' do
      @deleted = true
      id = @events.on(:unicorn_event) { @deleted = false }
      @events.del(id)
      @events.call(:unicorn_event)
      @deleted.must_equal true
    end
  end

end

# vim: set ts=4 sts=2 sw=2 et:
