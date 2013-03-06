# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Syndi

  # A mixin for easy access to the logging methods.
  module Logging

    %i[info error warn fatal verbose warn deprecate].each do |func|
      define_method(func) { |*args| Syndi.log.send func, *args }
    end

  end

end

# vim: set ts=4 sts=2 sw=2 et:
