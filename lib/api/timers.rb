# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Entering namespace: API
module API

  # Class Timers: Timer system.
  class Timers
    
    attr_reader :timers

    # Create a new instance of API::Timers.
    # ()
    def initialize
      @timers = {}
    end

    # Spawn a new timer.
    # (obj, num, sym, splat) {}
    def spawn(clr, time, type, *args, &cb)

      # Create a new container for this caller if it doesn't already exist.
      @timers[clr] = {} unless @timers.has_key? clr
      
      # Generate a unique ID for this timer.
      id = ''
      10.times { id += get_rand_char }
      while @timers[clr].has_key? id
        id = ''
        10.times { id += get_rand_char }
      end

      # Create a new thread containing the timer.
      # NOTE: This is probably not the best way to do this, but meh.
      if type == :once
        @timers[clr][id] = Thread.new { sleep time; cb.call(*args) }
      elsif type == :every
        @timers[clr][id] = Thread.new { loop { sleep time; cb.call(*args) } }
      else
        return
      end

      id

    end

    # Delete a timer.
    # (obj, id)
    def del(clr, id)
      # Does a container exist for this caller?
      if @timers.has_key? clr
        # Does the timer exist?
        if @timers[clr].has_key? id
          @timers[clr][id].kill
          @timers[clr].delete(id)
        end
      end
    end

    #######
    private
    #######

    # Get a random character.
    # () -> char
    def get_rand_char
      chrs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".split(//)
      chrs[rand(chrs.length)]
    end

  end # class Timers

end # module API
