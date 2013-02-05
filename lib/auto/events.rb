# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'auto/verbosity'

module Auto

  # A simple event management system, designed particularly for Auto.
  #
  # @!attribute [r] events
  #   @return [Hash{Symbol => Array<Auto::Events::Listener>}] The collection of events and associated listeners.
  class Events

    attr_reader :events

    def initialize
      @events = Hash.new
    end

    # Create a new listener on a given +event+, which will have the given
    # block attached and executed upon the event's occurrence.
    #
    # @param [Symbol] event The event which to await.
    # @param [Integer] priority The priority this listener should have in the hook
    #    execution procedure. Must be 1-5 with 1 being of utmost priority.
    #
    # @yield [...] The parameters passed when the event was broadcasted. This varies
    #   by event. See the official event reference for Auto events.
    #
    # @return [Auto::Events::Listener] The listener.
    def on event, priority = 3, &prc
      @events[event] ||= Array.new

      if priority < 1 || priority > 5
        raise ArgumentError, "invalid event priority specified"
      end

      hook = Listener.new self, event, priority, prc
      @events[event] << hook
      hook
    end

    # This will broadcast the given +event+, executing each listener and passing
    # to it the parameters supplied here, respecting priority and operating in a
    # thread.
    #
    # @param [Symbol] event
    # @param [...] parameters The arguments to be passed to each listener.
    def emit event, *parameters
      if @events[event]

        # collect the listeners with respect to priority
        one   = @events.collect { |hook| (hook.priority == 1 ? hook : nil) }.compact
        two   = @events.collect { |hook| (hook.priority == 2 ? hook : nil) }.compact
        three = @events.collect { |hook| (hook.priority == 3 ? hook : nil) }.compact
        four  = @events.collect { |hook| (hook.priority == 4 ? hook : nil) }.compact
        five  = @events.collect { |hook| (hook.priority == 5 ? hook : nil) }.compact

        Auto.log.verbose "event *#{event}* is being broadcasted on #{self}", VNOISY

        # spawn a thread and perform the executions
        Thread.new do
          begin
            # cease if status ever becomes false/nil
            status = true
            
            one.each   { |code| status = code.call parameters if status }
            two.each   { |code| status = code.call parameters if status }
            three.each { |code| status = code.call parameters if status }
            four.each  { |code| status = code.call parameters if status }
            five.each  { |code| status = code.call parameters if status }
          rescue => e
            # catch thread errors
            Auto.log.error "A listener to a broadcast of #{event} on #{self} caused an exception to rise (#{e})", true
          end
        end

      end
    end

    def inspect
      "<#Auto::Events: obj_id=#{object_id} event_count=#{@events.length}>"
    end
    alias_method :to_s, :inspect

    # A class which represents a listener.
    class Listener
      attr_reader :event, :priority, :code

      def initialize sys, event, priority, prc
        @sys      = sys
        @event    = event
        @priority = priority
        @code     = prc

        Auto.log.verbose "new listener spawned and attached to #{event}: #{self}", VNOISY
      end

      def deaf
        @sys.events[event].delete self
      end

      def inspect
        "<#Auto::Events::Listener: sys=#@sys event=#@event priority=#@priority proc={#@code}>"
      end
      alias_method :to_s, :inspect

    end

  end

end

# vim: set ts=4 sts=2 sw=2 et:
