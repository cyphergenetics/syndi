# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/irc/library'

module Syndi
  # Fetch the {Syndi::IRC::Client} object which represents a network.
  # @param [String] network The network to be fetched.
  def self.IRC network
    irc.networks[network.dc]
  end
end

LIBRARY_IRC = Syndi::IRC::Library.new

# vim: set ts=4 sts=2 sw=2 et:
