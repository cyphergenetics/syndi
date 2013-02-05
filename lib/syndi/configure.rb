# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Syndi

  # A configuration management suite.
  module Configure

    # syndi-conf version
    VERSION = '2.00'

    syndiload :CLI,       'syndi/configure/cli'
    syndiload :Generator, 'syndi/configure/generator'

  end

end

# vim: set ts=4 sts=2 sw=2 et:
