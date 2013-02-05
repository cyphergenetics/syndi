# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

# Namespace: Syndi
module Syndi

  # Namespace: DSL
  module DSL

    # A domain-specific language (DSL) wrapper mixin for simple usage of the events
    # system, {Syndi::API::Events}, and the timers system, {Syndi::API::Timers}.
    #
    # @api DSL
    # @author noxgirl
    # @since 4.0.0
    #
    # @see Syndi::API::Events
    # @see Syndi::API::Timers
    module Base
        
      # @see Syndi::API::Timers#spawn
      def clock_do(*args);   $m.clock.spawn(*args); end
      # @see Syndi::API::Timers#del
      def clock_stop(*args); $m.clock.del(*args);   end

      # Hook onto an event.
      #
      # @param [Symbol] system The events system to access.
      # @param [Symbol] event The event onto which to hook.
      #
      # @see Syndi::API::Events#on
      def on(sys, event, &prc)
        if sys == :syndi # central system
          $m.events.on(event, prc)
        else
          $m.send(sys).events.on(event, prc) if $m.respond_to? sys
        end
      end
      
      # Emit an event.
      #
      # @param [Symbol] system The events system to access.
      # @param [Symbol] event The event onto which to hook.
      #
      # @see Syndi::API::Events#call
      def emit(sys, event, *args)
        if sys == :syndi # central system
          $m.events.call(event, *args)
        else
          $m.send(sys).events.call(event, *args) if $m.respond_to? sys
        end
      end
      
      # Delete a hook.
      #
      # @param [Symbol] system The events system to access.
      # @param [Array(Symbol, Integer, String)] hook The identification data of the hook.
      #
      # @see Syndi::API::Events#del
      def undo_on(sys, hook)
        if sys == :syndi # central system
          $m.events.del(hook)
        else
          $m.send(sys).events.del(hook) if $m.respond_to? sys
        end
      end

    end # module Base

  end # module DSL

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
