# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Namespace: API
module API

  # Namespace: Resource
  module Resource

    # A mixin which acts as a DSL-type wrapper of {API::Events}.
    #
    # @api Auto
    # @since 4.0.0
    # @author noxgirl
    module EventsWrapper

      # Listen for (hook onto) an event.
      #
      # @param [Object] callero The object of the caller, or +self+ in the calling code.
      # @param [String] event The name of the event for which to listen.
      #
      # @yield [...] The arguments that will be yielded to the block vary by event.
      #   Please consult the {file:doc/Events.md API Events} document.
      #
      # @return [String] id A unique identifier string. Keep this if you need to destroy
      #   the hook later.
      #
      # @example
      #   ev_on self, 'irc:onDisconnect' do |irc|
      #     puts "I'm dying!"
      #   end
      #
      # @see API::Events#on
      def self.ev_on(callero, event, &callback)
        $m.events.on(callero, event, callback)
      end

      # Broadcast an event and associated arguments.
      #
      # The arguments are globbed into an array from the list passed to the
      # method, so be sure to format your call correctly.
      #
      # @param [String] event The name of the event being braodcasted.
      # @param [Array] args A list of arguments which should be passed to
      #   the listeners.
      #
      # @example
      #   ev_call 'foo:cowMoo', "the cows", "go moo", [1, 3, 5]
      #
      # @see API::Events#call
      def self.ev_call(event, *args)
        $m.events.call(event, *args)
      end

      # Destroy a previously created listener or hook.
      #
      # @param [Object] creatoro The object which created this hook--typically +self+.
      # @param [String] id The unique identifier string of the hook.
      #
      # @see API::Events#del
      def self.ev_drop(creatoro, id)
        $m.events.del(creatoro, id)
      end

    end # module EventsWrapper

  end # module Resource

end # module API

# vim: set ts=4 sts=2 sw=2 et:
