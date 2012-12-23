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
    include API::Resource::EventsWrapper

    attr_reader :list
    
    # Create a new instance of IRC::Commands.
    def initialize

      # Commands hash.
      @list = {}
      
      # Note core commands, deletion of which is prohibited.
      @core_commands = ['ACCESS', 'AUTOJOIN', 'HELP', 'IGNORE', 'REHASH', 'TERMINATE']

      # Prefix.
      unless $m.conf.x['irc'].include? 'commandPrefix'
        @prefix = '.'
      else
        @prefix = $m.conf.x['irc']['commandPrefix']
      end

      # Listen for channel messages.
      ev_on(self, 'irc:onRecvChanMsg') do |irc, sender, chan, msg|
        
        prefix = Regexp.escape(@prefix)
        # First check if this might be a command.
        if match = /^#{prefix}(\S+)$/.match(msg[0])
          command = match[1].uc
          # Now check if it is.
          if @list.include? command
            if @list[command][:type] == :public or @list[command][:type] == :global

              # TODO: Access support
            
              # Check parameter number.
              paramnum = msg.length
              if paramnum > @list[command][:paramreq]
            
                # Call command.
                params = nil
                if paramnum > 1
                  params = msg[1..-1]
                end
                sender << chan
                @list[command][:cb].call(irc, sender, params)

              else
                irc.notice(sender[0], "Insufficient parameters. See HELP #{command}.")
              end # if paranum sufficient
              
            end # if types match
          end # if is command
        end # if might be command

      end

      # Listen for private messages.
      ev_on(self, 'irc:onRecvPrivMsg') do |irc, sender, msg|

        # Check if this is a command.
        command = msg[0].uc
        if @list.include? command
          if @list[command][:type] == :private or @list[command][:type] == :global

            # TODO: Access support

            # Check parameter number.
            paramnum = msg.length
            if paramnum > @list[command][:paramreq]
            
              # Call command.
              params = nil
              if paramnum > 1
                params = msg[1..-1]
              end
              @list[command][:cb].call(irc, sender, params)

            else
              irc.notice(sender[0], "Insufficient parameters. See HELP #{command}.")
            end # if paranum sufficient

          end # if types match
        end # check if might be command
      
      end

      # Create HELP command.
      new_cmd('HELP', :global) do |irc, sender, params|

        # If they're not requesting help for a particular command, send a list of commands.
        if params.nil?
          # TODO: access
            
          list = ''
          
          # Send list depending on whether it is public or private.
          if sender.length == 4
            
            # public/global
            @list.each do |name, properties|
              if properties[:type] == :public or properties[:type] == :global
                if list == ''
                  list = "#@prefix#{name.dc}"
                else
                  list = "#{list}, #{@prefix+name.dc}"
                end
              end
            end
          
            irc.notice(sender[0], "List of usable commands: #{list}") 
          else
            
            # private/global
            @list.each do |name, properties|
              if properties[:type] == :private or properties[:type] == :global
                if list == ''
                  list = name
                else
                  list = "#{list}, #{name}"
                end
              end
            end

            irc.msg(sender[0], "List of usable commands: #{list}") 
          end # if sender.length

        
        else # Since they are . . .

          # Check if this command exists.
          command = params[0].uc
          if @list.include? command
            if sender.length == 4 
              if @list[command][:type] == :public or @list[command][:type] == :global 
                # Send help. TODO access
                irc.notice(sender[0], "Help for \002#{command}\002: #{@list[command][:help]}")
              else # Else, notify them that this command does not exist.
                irc.notice(sender[0], "Unknown command \002#{command}\002. Please see \"#{@prefix}help\" for a list of commands.")
              end
            else
              if @list[command][:type] == :private or @list[command][:type] == :global 
                # Send help. TODO access
                irc.msg(sender[0], "Help for \002#{command}\002: #{@list[command][:help]}")
              else # Else, notify them that this command does not exist.
                irc.privmsg(sender[0], "Unknown command \002#{command}\002. Please see \"HELP\" for a list of commands.")
              end
            end
          end

        end # if params.nil?

      end # new_cmd()
              
    end # def initialize

    # new_cmd(name, type, paramreq, access, help) { |irc, sender, params| }
    def new_cmd(name, type, paramreq=0, access=nil, help='Unavailable.', &cb)
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
      @list[name][:type]     = type
      @list[name][:paramreq] = paramreq
      @list[name][:access]   = access
      @list[name][:help]     = help
      @list[name][:cb]       = cb

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
