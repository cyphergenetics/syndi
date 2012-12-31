# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Namespace: Auto
module Auto

  # Namespace: API
  module API

    # Namespace: Helper
    module Helper

      # A domain-specific language (DSL) wrapper mixin for simple usage of the events
      # system, {Auto::API::Events}.
      #
      # @api DSL
      # @author noxgirl
      # @since 4.0.0
      #
      # @see Auto::API::Events
      module Events

        # @see Auto::API::Events#on
        def ev_on(*args); $m.events.on(*args);   end
        # @see Auto::API::Events#call
        def ev_do(*args); $m.events.call(*args); end
        # @see Auto::API::Events#del
        def ev_rm(*args); $m.events.del(*args);  end

      end # module Events

    end # module Helper

  end # module API

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
