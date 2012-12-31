# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

require 'thread'

# Entering namespace: Auto
module Auto

  # Entering namespace: API
  module API

    # A simple class which provides the API a fundamental timer system, based on
    # threading.
    #
    # @api Auto
    # @since 4.0.0
    # @author noxgirl
    #
    # @!attribute [r] timers
    #   @return [Hash{String => Thread}] List of threads.
    class Timers < Auto::API::Object
    
      attr_reader :timers

      # Create a new instance of Auto::API::Timers.
      def initialize
        @timers = {}
      end

      # Spawn a new timer.
      #
      # @param [Integer] time Number of seconds before this is executed, or in between executions.
      # @param [Symbol] type Either +:once+ to execute a timer once and destroy it, or +:every+
      #   to repeat.
      # @param [Array<>] args An array of arguments which to pass to the block when executed. (splat)
      #
      # @yield [...] The arguments which were provided in the timer's creation.
      #
      # @return [String] A unique identification string representing the timer. Useful if you wish
      #   to terminate it in the future.
      #
      # @example
      #   => timer = timers.spawn(15, :once, 'cow') { |animal| puts animal }
      #   # after 15 seconds...
      #   'animal'
      #
      # @see Auto::API::Helper::Timers#clock_do
      def spawn(time, type, *args, &cb)

        # Generate a unique ID for this timer.
        id = ''
        10.times { id += get_rand_char }
        while @timers.has_key? id
          id = ''
          10.times { id += get_rand_char }
        end

        # Create a new thread containing the timer.
        if    type == :once
          @timers[id] = Thread.new { sleep time; cb.call(*args) }
        elsif type == :every
          @timers[id] = Thread.new { loop { sleep time; cb.call(*args) } }
        else
          return
        end

        id

      end

      # Delete a timer.
      #
      # @param [String] id The unique identification string of the timer, as provided
      #   by {#spawn}.
      #
      # @see Auto::API::Helper::Timers#clock_stop
      def del(id)
        # Does the timer exist?
        if @timers.has_key? id
          @timers[id].kill
          @timers.delete id
        end
      end

    end # class Timers

  end # module API

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
