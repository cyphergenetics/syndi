# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

#############################################
# IRC::Commands
#
# API library for management of IRC commands.
#############################################

# Namespace: IRC
module IRC

  # Class: Commands
  class Commands

    attr_reader :list
    
    # Create a new instance of IRC::Commands.
    def initialize

      # Commands hash.
      @list = {}
      
      # Note core commands, deletion of which is prohibited.
      @core_commands = []

      # Listen for channel messages.
      $m.events.on('irc:onRecvChanMsg') do |irc, sender, chan, msg|
      

      end

      # Listen for private messages.
      $m.events.on('irc:onRecvPrivMsg') do |irc, sender, msg|

      
      end

    end # def initialize

    # new_cmd(name, type, access, help) { |irc, sender, params| }
    def new_cmd(name, type, access=nil, help='Unavailable.', &cb)
      name = name.uc

      # No duplicates.
      if @list.include? name
        raise RuntimeError, "Unable to create command #{name} because it already exists."
      end

      # Weed out an invalid type.
      if type != :private and type != :public and type != :global
        raise RuntimeError, "Unable to create command #{name} because provided type #{type} is invalid."
      end

      # Create the command.
      @list[name] = {}

      # Populate its hash.
      @list[:type]   = type
      @list[:access] = access
      @list[:help]   = help
      @list[:cb]     = cb

    end

    # del_cmd(name)
    def del_cmd(name)
      name = name.uc

      # Check if it exists.
      unless @list.include? name
        raise RuntimeError, "Unable to delete command #{name} because it does not exist."
      end

      # Ensure it is not protected.
      if is_protected? name
        raise RuntimeError, "Unable to delete command #{name} because it is a protected command essential to irc module."
      end

      @list.delete name

    end

    #######
    private
    #######

    def is_protected?(cmd)
      @core_commands.include? cmd.uc
    end

  end # class Commands

end # module IRC

# vim: set ts=4 sts=2 sw=2 et:
