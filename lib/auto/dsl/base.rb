# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

# Namespace: Auto
module Auto

  # Namespace: DSL
  module DSL

    # A domain-specific language (DSL) wrapper mixin for simple usage of the events
    # system, {Auto::API::Events}, and the timers system, {Auto::API::Timers}.
    #
    # @api DSL
    # @author noxgirl
    # @since 4.0.0
    #
    # @see Auto::API::Events
    # @see Auto::API::Timers
    module Base
        
      # @see Auto::API::Timers#spawn
      def clock_do(*args);   $m.clock.spawn(*args); end
      # @see Auto::API::Timers#del
      def clock_stop(*args); $m.clock.del(*args);   end

      # Hook onto an event.
      #
      # @param [Symbol] system The events system to access.
      # @param [Symbol] event The event onto which to hook.
      #
      # @see Auto::API::Events#on
      def on(system, event, &prc)
        if system == :auto # central system
          $m.events.on(event, prc)
        else
          $m.instance_variable_get("@#{system.to_s}").events.on(event, prc)
        end
      end
      
      # Emit an event.
      #
      # @param [Symbol] system The events system to access.
      # @param [Symbol] event The event onto which to hook.
      #
      # @see Auto::API::Events#call
      def emit(system, event, *args)
        if system == :auto # central system
          $m.events.call(event, *args)
        else
          $m.instance_variable_get("@#{system.to_s}").events.call(event, *args)
        end
      end
      
      # Delete a hook.
      #
      # @param [Symbol] system The events system to access.
      # @param [Array(Symbol, Integer, String)] hook The identification data of the hook.
      #
      # @see Auto::API::Events#del
      def undo_on(system, hook)
        if system == :auto # central system
          $m.events.del(hook)
        else
          $m.instance_variable_get("@#{system.to_s}").events.del(hook)
        end
      end

    end # module Base

  end # module DSL

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
