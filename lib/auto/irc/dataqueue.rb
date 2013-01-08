# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'thread'

module Auto

  module IRC

    # A class for interthread synchronization of incoming IRC traffic which is
    # a subclass of the Ruby standard library's {Queue}.
    class DataQueue < Queue

      # An alias for {#push} which accepts multiple arguments.
      #
      # @param [Array<Object>] arr Objects which to #push.
      def in *arr
        arr.each { |objekt| push objekt }
      end

    end # class DataQueue

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
