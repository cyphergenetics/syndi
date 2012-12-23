# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

##########################################################################
# IRC::Std
#
# A module which binds to all standard IRC commands and numerics, provides
# basic IRC functions, and interfaces these to the event system for easy
# use.
##########################################################################

# Entering namespace: IRC
module IRC

  # Entering namespace: Std
  module Std
    include API::Resource::EventsWrapper

    # Bind to all standard IRC commands.
    # ()
    def self.init

      ###########
      # LISTENS #
      ###########
      
      $m.irc_parser.listen('AUTHENTICATE', :zero)
      $m.irc_parser.listen('CAP', :one)
      $m.irc_parser.listen('JOIN', :one)
      $m.irc_parser.listen('KICK', :one)
      $m.irc_parser.listen('NICK', :one)
      $m.irc_parser.listen('NOTICE', :one)
      $m.irc_parser.listen('PART', :one)
      $m.irc_parser.listen('PING', :zero)
      $m.irc_parser.listen('PRIVMSG', :one)
      $m.irc_parser.listen('QUIT', :one)
      
      $m.irc_parser.listen('001', :one)
      $m.irc_parser.listen('005', :one)
      $m.irc_parser.listen('352', :one)
      $m.irc_parser.listen('353', :one)
      $m.irc_parser.listen('433', :one)
      $m.irc_parser.listen('903', :one)
      $m.irc_parser.listen('904', :one)

      #########
      # BINDS #
      #########

      ### COMMANDS ###
      
      # AUTHENTICATE
      ev_on(self, 'irc:onRaw0:AUTHENTICATE') do |irc, data|
        
        if data[1] == '+'
          # Import Base64.
          begin
            require 'base64'
          rescue => e
            irc.snd('CAP END')
            $m.timers.del(irc.sasl_id)
            $m.error("Failed to authenticate to #{irc} using SASL: #{e}", false, e.backtrace)
            return
          end

          # Encrypt the combination.
          username = $m.conf.x['irc'][irc.s]['SASL']['username']
          password = $m.conf.x['irc'][irc.s]['SASL']['password']
          enc = Base64.encode64([username, username, password].join("\0")).gsub(/\n/, '')
          
          # Send it.
          if enc.length == 0
            irc.snd("AUTHENTICATE +")
          else
            
            while enc.length >= 400
              irc.snd("AUTHENTICATE #{enc[0..400]}")
              enc[0..400] = ''
            end

            if enc.length > 0 then irc.snd("AUTHENTICATE #{enc}")
            else irc.snd("AUTHENTICATE +")
            end

          end
        end
      
      end
      
      # CAP
      ev_on(self, 'irc:onRaw1:CAP') do |irc, data|
        # LS
        if data[3] == 'LS'
          req = []
          data[4].sub!(/^:/, '')
          
          # Request multi-prefix.
          if data[4..-1].include? 'multi-prefix'
            req << 'multi-prefix'
          end

          # If we're supposed to be using SASL, request it.
          if $m.conf.x['irc'][irc.s].include?('SASL') and data[4..-1].include? 'sasl'
            req << 'sasl'
          end

          # Send our requests.
          irc.snd("CAP REQ :#{req.join(' ')}")

        # ACK
        elsif data[3] == 'ACK'
          data[4].sub!(/^:/, '')
          # Check for SASL.
          if data[4..-1].include? 'sasl'
            irc.snd('AUTHENTICATE PLAIN')
            irc.sasl_id = $m.timers.spawn(irc, $m.conf.x['irc'][irc.s]['SASL']['timeout'], :once) do
              irc.snd('CAP END')
            end
          else
            irc.snd('CAP END')
          end
        end
      end

      # JOIN

      # KICK

      # NICK

      # NOTICE

      # PART

      # PING
      ev_on(self, 'irc:onRaw0:PING') do |irc, data|
        irc.snd("PONG #{data[1]}")
      end

      # PRIVMSG
      ev_on(self, 'irc:onRaw1:PRIVMSG') do |irc, data|
        sender = parse_mask(data[0])
        
        # Check if it's a CTCP VERSION.
        if data[3] =~ /^:\001VERSION\001$/
          irc.notice(sender[0], "\001VERSION Auto #{VERSION} (http://noxgirl.github.com/Auto)\001")
        else # Else, call msg events.
          if data[2] == irc.nick
            #irc:onRecvPrivMsg <- (irc, sender, msg)
            data[3].sub!(/^:/, '')
            $m.events.call('irc:onRecvPrivMsg', irc, sender, data[3..-1])
          else
            # irc:onRecvChanMsg <- (irc, sender, channel, msg)
            data[3].sub!(/^:/, '')
            $m.events.call('irc:onRecvChanMsg', irc, sender, data[2], data[3..-1])
          end
        end

      end

      # QUIT

      ### NUMERICS ###

      # 005: RPL_ISUPPORT
      ev_on(self, 'irc:onRaw1:005') do |irc, data|

        # Iterate through the parameters.
        data[3..-1].each do |param|
          name, val = param.split('=', 2)

          case name

          # MODES: Max modes in a single /MODE.
          # Format: (int)
          when 'MODES'
           irc.max_modes = val.to_i

          # PREFIX: Supported prefixes.
          # Format: (modes)[!~&@%+]
          when 'PREFIX'
            # Fetch the modes and prefixes.
            re = /\((.+)\)(.*)/.match(val)

            # Split the modes and prefixes.
            modes = re[1].split(//)
            prefixes = re[2].split(//)

            # The amount of modes must match the amount of prefixes.
            if modes.length != prefixes.length
              $m.error("RPL_ISUPPORT from #{irc}: Prefixes and modes do not match. Closing connection.", false)
              irc.disconnect("Unable to recover from state data error.")
            end

            # Now match them up.
            modes.each_with_index { |m, i| irc.prefixes[m] = prefixes[i] }

          # CHANMODES: Supported channel modes.
          # Format: list,always,set,never
          when 'CHANMODES'
            list, always, set, never = val.split(',', 4)

            irc.channel_modes[:list]   = list.split(//)
            irc.channel_modes[:always] = always.split(//)
            irc.channel_modes[:set]    = set.split(//)
            irc.channel_modes[:never]  = never.split(//)

          end # case

        end # each

      end # do

      # 352: RPL_WHOREPLY
      ev_on(self, 'irc:onRaw1:352') do |irc, data|
        
        # Check if we're awaiting a reply on our self-WHO.
        if irc.await_self_who
          
          # Username
          irc.user = data[4]
          # Hostname
          irc.mask = data[5]
          # Nickname
          irc.nick = data[7]
          # Real name
          irc.real = data[10..-1]

          irc.await_self_who = false

        end

        # Call irc:onWhoReply <- (irc, nick, username, host, realname, awaystatus, server)
        $m.events.call('irc:onWhoReply', irc, data[7], data[4], data[5], data[10..-1], data[8], data[6])

      end

      # 353: RPL_NAMEREPLY
      ev_on(self, 'irc:onRaw1:353') do |irc, data|


      end

      # 433: ERR_NICKNAMEINUSE
      ev_on(self, 'irc:onRaw1:433') do |irc, data|
        
        # Our desired nickname is in use. Check if the config has an alternative.
        index = $m.conf.x['irc'][irc.s]['nickname'].index(data[3])
        if $m.conf.x['irc'][irc.s]['nickname'].length > index+1
          # Change nickname.
          irc.chgnick($m.conf.x['irc'][irc.s]['nickname'][index+1])
          $m.warn("Nickname #{data[3]} is in use on #{irc}. Trying alternative nickname #{$m.conf.x['irc'][irc.s]['nickname'][index+1]}...")
        else # If there is not one, try to make one.
          newnick = "#{data[3]}-"
          irc.chgnick(newnick)
          $m.warn("Nickname #{data[3]} is in use on #{irc}. Trying alternative (generated) nickname #{newnick}...")
        end
        
      end
      
      # 903: RPL_SASLSUCCESS
      ev_on(self, 'irc:onRaw1:903') do |irc, data|
        
        # SASL authentication was successful.
        $m.info("SASL authentication to #{irc} successful.")
        $m.timers.del(irc, irc.sasl_id)
        irc.sasl_id = nil
        irc.snd('CAP END')
      
      end

      # 904: RPL_SASLFAIL
      ev_on(self, 'irc:onRaw1:904') do |irc, data|
        
        # SASL authentication failed.
        $m.info("SASL authentication to #{irc} failed.")
        $m.timers.del(irc, irc.sasl_id)
        irc.sasl_id = nil
        irc.snd('CAP END')
      
      end

    end # def init

    # parse_mask(str): Parse a mask of nick!user@host.
    # <- (nick, user, host)
    def self.parse_mask(mask)
      data = %r{^:([0-9a-zA-Z]+)!(.+)@(.+)$}.match(mask)
      return data[1], data[2], data[3]
    end

    # array_msg_to_str: Change an array of data (the body of a message) into a united string.
    def self.array_msg_to_str(array)
      str = ''
      array.each do |item|
        if str == ''
          str = item
        else
          str = "#{str} #{item}"
        end
      end
      str.sub!(/^:/, '')

      str
    end

  end # module Std

end # module IRC

# vim: set ts=4 sts=2 sw=2 et:
