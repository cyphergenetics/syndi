# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/events'

describe Syndi::Events do

  before do
    @events = Syndi::Events.new
  end

  describe '#on' do
    
    it 'listens for an event' do
      @events.on(:moo) do |magic|
       magic = true
      end

      @rawr = false
      @events.emit :moo, @rawr
      sleep 0.1

      expect(@rawr).to be_true
    end

    it 'returns a listener' do
      expect do
        @events.on(:cows) { nil }
      end.to be_an_instance_of Syndi::Events::Listener
    end

    context 'when given a priority outside 1..5' do
      it 'raises an ArgumentError' do
        expect { @events.on(:meowbar, 6) { nil } }.to raise_error ArgumentError
      end
    end

  end

  describe '#emit' do
    
    it 'broadcasts an event' do
      @events.on(:fairy) do |cat|
        @cat = cat
      end

      @cat = false
      @events.emit :fairy, true
      sleep 0.1

      expect(@cat).to be_true
    end

    it 'respects priority' do
      @order = ''
      @events.on(:a, 1) { @order << 'A' }
      @events.on(:a, 3) { @order << 'B' }
      @events.on(:a, 5) { @order << 'C' }

      @events.emit :a
      sleep 0.1

      expect(@order).to eq 'ABC'
    end

  end

  describe Syndi::Events::Listener do

    describe '#deaf' do

      it 'terminates a listener' do
        @ok = true
        hook = @events.on(:beep) { @ok = false }
        hook.deaf

        @events.emit :beep
        sleep 0.1

        expect(@ok).to be_true
      end

    end

  end

end

# vim: set ts=4 sts=2 sw=2 et:
