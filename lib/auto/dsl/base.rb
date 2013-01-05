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

      # @see Auto::API::Events#on
      def ev_on(*args); $m.events.on(*args);   end
      # @see Auto::API::Events#call
      def ev_do(*args); $m.events.call(*args); end
      # @see Auto::API::Events#del
      def ev_rm(*args); $m.events.del(*args);  end

    end # module Base

  end # module DSL

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
