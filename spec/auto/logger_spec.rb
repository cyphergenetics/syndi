# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'auto/events'

describe Auto::Events do

  before do
    @events = Auto::Events.new
  end

  describe '#on' do
    
    it 'listens for an event' do
      @events.on(:moo) do |magic|
       magic = true
      end

      rawr = false
      @events.emit :moo, rawr

      expect { rawr }.to be_true
    end

    it 'returns a listener' do
      expect do
        @events.on(:cows) { nil }
      end.to be_an_instance_of Auto::Events::Listener
    end

  end

  describe '#emit'

  describe Auto::Events::Listener

    describe '#deaf'

  end

end

# vim: set ts=4 sts=2 sw=2 et:
