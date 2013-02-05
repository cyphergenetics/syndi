# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

# Namespace: Syndi
module Syndi

  # Namespace: API
  module API

    # A superclass for {Syndi::API::Timers} and {Syndi::API::Events}.
    class Object

      private

      # Get a random character.
      #
      # @return [String] A random character.
      def get_rand_char
        chrs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".split(//)
        chrs[rand(chrs.length)]
      end

    end # class Object

  end # module API

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
