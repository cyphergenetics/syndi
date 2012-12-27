# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

module Auto
  class Auto
    [:debug,:warn,:error,:log,:info,:foreground].each do |x| 
      define_singleton_method(x) {|*args| nil }
    end
  end
end

# vim: set ts=4 sts=2 sw=2 et:
