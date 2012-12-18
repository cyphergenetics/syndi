# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

#############################################################################
# IRC::Parser
#
# A simple class which provides a basic, foundational parser for IRC traffic.
#############################################################################

# Entering namespace: IRC
module IRC

  # Class Parser: Parser for incoming IRC data.
  class Parser

    attr_reader :commands

    # Create a new instance of IRC::Parser.
    # ()
    def initialize
      @commands = { :zero => {}, :one => {} }
    end

    # Listen for a command.
    # (str, sym)
    def listen(command, level)
      # Check for a valid level.
      if level == :zero or level == :one
        if !@commands[level].has_key? command.uc
          @commands[level][command.uc] = 1
        end
      end
    end

    # Parse incoming data.
    # (obj, str)
    def parse(irc, raw)
      
      data = raw.split(/\s+/)

      # Are we listening for a command in this data?
      if @commands[:zero].has_key? data[0]
        $m.events.call("irc:onRaw0:#{data[0]}", irc, data)
      end

      if @commands[:one].has_key? data[1]
        $m.events.call("irc:onRaw1:#{data[1]}", irc, data)
      end

    end

  end # class Parser

end # module IRC

# vim: set ts=4 sts=2 sw=2 et:
