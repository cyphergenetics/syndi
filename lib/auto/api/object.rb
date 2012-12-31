# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

# Namespace: Auto
module Auto

  # Namespace: API
  module API

    # A superclass for {Auto::API::Timers} and {Auto::API::Events}.
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

end # module Auto

# vim: set ts=4 sts=2 sw=2 et: