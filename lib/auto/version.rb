# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

module Auto
  
  # Standard version string.
  #
  # We use semantic versioning: +MAJOR.MINOR.PATCH.PRE.PRENUM+
  VERSION      = '4.0.0.alpha.1'.freeze

  # Standard version plus the codename (assigned to each minor release).
  #
  # i.e., +VERSION-CODENAME+
  FULLVERSION  = "#{VERSION}-phoenix".freeze

end

# vim: set ts=4 sts=2 sw=2 et:
