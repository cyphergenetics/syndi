# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'auto/irc/std/numerics'

module Auto

  module IRC

    class Protocol

      # An extension of {Auto::IRC::Protocol}, which parses numerics.
      module Numerics
        include Auto::IRC::Std::Numerics


      end # class Numerics

    end # class Protocol

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
