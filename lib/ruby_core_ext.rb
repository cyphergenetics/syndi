# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

###
# Changing standard class String
###
class String
  # Alias 'uc' to 'upcase', for making life easier.
  alias_method 'uc', 'upcase'
  # And 'dc' to 'downcase'.
  alias_method 'dc', 'downcase'
end

# vim: set ts=4 sts=2 sw=2 et:
