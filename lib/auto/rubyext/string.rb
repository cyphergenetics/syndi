# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

# This changes the String class in Ruby's standard library to make life easier
# by aliasing String#uc to String#upcase and String#dc to String#downcase
class String
  alias uc, upcase
  alias dc, downcase
  alias uc!, upcase!
  alias dc!, downcase!
end

# vim: set ts=4 sts=2 sw=2 et:
