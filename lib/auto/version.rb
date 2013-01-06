# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto
  VERSIONSPEC  = {
    major:    4,
    minor:    0,
    patch:    0,
    pre:      'a.0.2',
    codename: 'phoenix'
  }.freeze
  VERSION      = "#{VERSIONSPEC[:major]}.#{VERSIONSPEC[:minor]}.#{VERSIONSPEC[:patch]}"
  VERSION.concat '.'+VERSIONSPEC[:pre] if VERSIONSPEC.include? :pre
  VERSION.freeze
  FULLVERSION  = "#{VERSION}-#{VERSIONSPEC[:codename]}".freeze
end

# vim: set ts=4 sts=2 sw=2 et:
