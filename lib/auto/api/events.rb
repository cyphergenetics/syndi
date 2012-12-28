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
    class Events

      # Create a new instance of API::Events.
      # ()
      def initialize
        @events = {}
      end

      # Bind (hook) to an event.
      # (obj, str) {} -> str:id
      def on(clr, event, &cb)

        # Create a container for this calling object if it doesn't already exist.
        unless @events.has_key? clr
          @events[clr] = {}
        end

        # Generate a unique ID for this hook.
        id = ''
        10.times { id += get_rand_char }
        while @events[clr].has_key? id
          id = ''
          10.times { id += get_rand_char }
        end

        # Create the hook in memory.
        @events[clr][id] = [event, cb]

        id

      end

      # Call an event.
      # (str, *args)
      def call(evnt, *args)
        # Iterate through our events.
        @events.each do |clr, events|
          events.each do |id, event|
            if event[0] == evnt
              event[1].call(*args)
            end
          end
        end
      end

      # Delete a hook.
      # (obj, str)
      def del(clr, id)
        if @events.has_key? clr
          @events[clr].delete(id)
        end
      end

      #######
      private
      #######

      # Get a random character.
      # () -> char
      def get_rand_char
        chrs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".split(//)
        chrs[rand(chrs.length)]
      end

    end # class Events

  end # module API

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
