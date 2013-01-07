# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto
  module IRC
    module SASL
      module Mech
        autoload :DHBlowfish, 'auto/irc/sasl/mech/dh_blowfish'
        autoload :Plain,      'auto/irc/sasl/mech/plain'
      end
    end
  end
end

# vim: set ts=4 sts=2 sw=2 et:
