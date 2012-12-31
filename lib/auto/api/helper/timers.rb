# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# namespace Auto
module Auto

  # namespace API
  module API

    # namespace Helper
    module Helper

      # This is a domain-specific language (DSL) wrapper mixin for {Auto::API::Timers}.
      #
      # @api DSL
      # @since 4.0.0
      # @author noxgirl
      #
      # @see Auto::API::Timers
      module Timers

        # @see Auto::API::Timers#spawn
        def clock_do(*args);   $m.clock.spawn(*args); end
        # @see Auto::API::Timers#del
        def clock_stop(*args); $m.clock.del(*args);   end

      end # module Timers

    end # module Helper

  end # module API

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
