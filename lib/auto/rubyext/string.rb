# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# This changes the String class in Ruby's standard library to make life easier
# by aliasing String#uc to String#upcase and String#dc to String#downcase
class String
  # Alias 'uc' to 'upcase', for making life easier.
  alias_method 'uc', 'upcase'
  # And 'dc' to 'downcase'.
  alias_method 'dc', 'downcase'
end

# vim: set ts=4 sts=2 sw=2 et: