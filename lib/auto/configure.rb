# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Auto

  # A configuration management suite.
  module Configure

    # auto-conf version
    VERSION = '2.00'

    autoload :CLI,       'auto/configure/cli'
    autoload :Generator, 'auto/configure/generator'

  end

end

# vim: set ts=4 sts=2 sw=2 et:
