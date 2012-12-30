# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Entering namespace: Auto
module Auto

  # Entering namespace: API
  module API

    # A class which provides the API the fundamental event system, upon which
    # much of the API is based, and which follows a simple model of broadcasting
    # and hooking onto such broadcasts.
    #
    # @api Auto
    # @since 4.0.0
    # @author noxgirl
    #
    # @see Auto::API::Helper::Events
    class Events

      # Create a new instance of Auto::API::Events.
      def initialize
        @events = {}
      end

      # Listen for (hook onto) an event.
      #
      # @param [String] event The name of the event for which to listen.
      # @param [Integer] priority The priority of the event from 1-5, 1 being utmost priority.
      #
      # @yield [...] The arguments that will be yielded to the block vary by event.
      #   Please consult the {file:doc/Events.md API Events} document.
      #
      # @return [Array(String, Integer, String)] Identification data including a unique string. Keep 
      #   this if you need to destroy the hook later.
      #
      # @example
      #   events.on 'irc:onDisconnect' do |irc|
      #     puts "I'm dying!"
      #   end
      #
      # @see API::Helper::Events#ev_on
      def on(event, priority=3, &cb)

        # Priority must be in the range of 1-5.
        unless (1..5).include? priority
          return 0
        end

        # If the event does not exist, create it.
        unless @events.include? event
          new_event event
        end

        # Generate a unique ID for this hook.
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
      # @param [String] event The name of the event being braodcasted.
      # @param [Array] args A list of arguments which should be passed to
      #   the listeners. (splat)
      #
      # @example
      #   events.call('foo:cowMoo', "the cows", "go moo", [1, 3, 5])
      #
      # @see API::Helper::Events#ev_do
      def call(evnt, *args)
        # Check if any hooks exist for this event.
        if @events.include? evnt
          # Iterate through the hooks.
          @events[evnt].each_key do |priority|
            @events[evnt][priority].each_value do |prc| 
              Thread.new(prc) do |process|
                process.call(*args)
              end.join
            end
          end
        end
      end

      # Delete a hook or listener.
      #
      # @param [Array(String, Integer, String)] id The identification data of the hook,
      #   as provided by #on.
      #
      # @see API::Helper::Events#ev_del
      def del(id)
        event, priority, hook = id

        if @events.has_key? event
          if @events[event][priority].has_key? hook
            @events[event][priority].delete(hook)
          end
        end

        tidy!
      end

      #######
      private
      #######

      # Get a random character.
      #
      # @return [String] A random character.
      def get_rand_char
        chrs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".split(//)
        chrs[rand(chrs.length)]
      end

      # Add a new event to the @events hash.
      #
      # @param [String] event Event name.
      def new_event(event)
        @events[event] = {
                          1 => {},
                          2 => {},
                          3 => {},
                          4 => {},
                          5 => {}
                         }
      end

      # Tidy up.
      def tidy!
        @events.each do |name, lists|
          empty = true
          empty = lists.each_value { |v| break false if not v.empty? }
          if empty
            @events.delete name
            next
          end
        end
      end

    end # class Events

  end # module API

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
