# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Syndi
  module IRC
    module SASL
      module Mech
        syndiload :DHBlowfish, 'syndi/irc/sasl/mech/dh_blowfish'
        syndiload :Plain,      'syndi/irc/sasl/mech/plain'
      end
    end
  end
end

# vim: set ts=4 sts=2 sw=2 et:
