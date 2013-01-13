# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

module Auto
  VERSIONSPEC  = {
    major:    4,
    minor:    0,
    patch:    0,
    pre:      'alpha.1',
    codename: 'phoenix'
  }.freeze
  VERSION      = "#{VERSIONSPEC[:major]}.#{VERSIONSPEC[:minor]}.#{VERSIONSPEC[:patch]}"
  VERSION.concat '.'+VERSIONSPEC[:pre] if VERSIONSPEC.include? :pre
  VERSION.freeze
  FULLVERSION  = "#{VERSION}-#{VERSIONSPEC[:codename]}".freeze
end

# vim: set ts=4 sts=2 sw=2 et:
