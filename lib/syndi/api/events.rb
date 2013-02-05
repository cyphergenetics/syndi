# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'thread'
require 'syndi/verbosity'
require 'syndi/api/object'

# Entering namespace: Syndi
module Syndi

  # Entering namespace: API
  module API

    # A class which provides the the fundamental event system, upon which
    # much of the API is based, and which follows a simple model of broadcasting
    # and hooking onto such broadcasts.
    #
    # Plugin writers may be rather interested in {Syndi::DSL::Base}, since that
    # provides a simpler interface to Syndi's instances of this class.
    #
    # @api Syndi
    # @since 4.0.0
    # @author noxgirl
    #
    # @see Syndi::DSL::Base
    #
    # @!attribute [r] threads
    #   @return [Array] An array of threads used by {#call}.
    class Events < Syndi::API::Object

      attr_reader :events, :threads

      # Create a new instance of Syndi::API::Events.
      def initialize
        @events  = {}
        @threads = []
      end

      # Listen for (hook onto) an event.
      #
      # @param [Symbol] event The name of the event for which to listen.
      # @param [Integer] priority The priority of the event from 1-5, 1 being utmost priority.
      #
      # @yield [...] The arguments that will be yielded to the block vary by event.
      #   Please consult with the {file:docs/Events.md events specification} for details by event.
      #
      # @return [Array(Symbol, Integer, String)] Identification data including a unique string. Keep 
      #   this if you need to destroy the hook later.
      #
      # @example
      #   events.on :disconnect do |irc|
      #     puts "I'm dying!"
      #   end
      #
      # @see Syndi::DSL::Base#on
      # @see file:docs/Events.md
      def on(event, priority=3, &cb)

        # Priority must be in the range of 1-5.
        unless (1..5).include? priority
          return 0
        end

        # If the event does not exist, create it.
        @events[event] ||= {1 => {}, 2 => {}, 3 => {}, 4 => {}, 5 => {}}

        # Generate a unique pseudorandom ID for this hook.
        id = ''
        10.times { id += get_rand_char }
        while @events[event][priority].has_key? id
          id = ''
          10.times { id += get_rand_char }
        end

        # Create the hook in memory.
        @events[event][priority][id] = cb

        [event, priority, id]

      end

      # Broadcast an event and associated arguments.
      #
      # The arguments are globbed into an array from the list passed to the
      # method, so be sure to format your call correctly.
      #
      # If a hook returns +false+, all subsequent hook executions will be
      # forestalled from occurring.
      #
      # @param [Symbol] event The event being broadcasted.
      # @param [Array] args A list of arguments which should be passed to
      #   the listeners. (splat)
      #
      # @example
      #   events.call(:cow_moo, "the cows", "go moo", [1, 3, 5])
      #
      # @see Syndi::DSL::Base#emit
      def call(event, *args)
        # Check if any hooks exist for this event.
        if @events.include? event
          
          $m.verbose("A thread is spawning for an event broadcast (:#{event}).", VNOISY) do
            @threads << Thread.new(event) do |evnt|
            
              status = nil
              
              begin # catch exceptions
                # Iterate through the hooks.
                @events[evnt].each_key do |priority|
                  @events[evnt][priority].each_value do |prc|
                    status = prc.call(*args) unless status == false
                  end # each hook
                end # each priority
              rescue => e
                $m.error "An exception occurred within the thread of :#{event}: #{e}", false, e.backtrace
              end # begin
            
            end # thread
          end # verbose
        
        end # whether this event exists
      end

      # Delete a hook or listener.
      #
      # @param [Array(Symbol, Integer, String)] id The identification data of the hook,
      #   as provided by #on.
      #
      # @see Syndi::DSL::Base#undo_on
      def del(id)
        event, priority, hook = id

        if @events.has_key? event
          if @events[event][priority].has_key? hook
            @events[event][priority].delete(hook)
          end
        end

        tidy
      end

      # Terminate all active threads.
      def die
        @threads.each { |thr| thr.kill }
      end

      #######
      private
      #######

      # Tidy up.
      def tidy
        @events.each do |name, lists|
          empty = true
          empty = lists.each_value { |v| break false if not v.empty? }
          if empty
            # Drop the event.
            @events.delete name
            next
          end
        end
      end

    end # class Events

  end # module API

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et: