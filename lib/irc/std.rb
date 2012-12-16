# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Entering namespace: IRC
module IRC

  # Entering namespace: Std
  module Std

    # Bind to all standard IRC commands.
    # ()
    def self.init

      ###########
      # LISTENS #
      ###########
      
      $m.irc_parser.listen('AUTHENTICATE', :zero)
      $m.irc_parser.listen('CAP', :one)
      $m.irc_parser.listen('JOIN', :one)
      $m.irc_parser.listen('NOTICE', :one)
      $m.irc_parser.listen('PART', :one)
      $m.irc_parser.listen('PING', :zero)
      $m.irc_parser.listen('PRIVMSG', :one)
      
      $m.irc_parser.listen('001', :one)
      $m.irc_parser.listen('005', :one)
      $m.irc_parser.listen('903', :one)
      $m.irc_parser.listen('904', :one)

      #########
      # BINDS #
      #########

      ### COMMANDS ###
      
      # AUTHENTICATE
      $m.events.on(self, 'irc:onRaw0:AUTHENTICATE') do |irc, data|
        
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
          username = $m.conf.x['irc'][irc]['SASL']['username']
          password = $m.conf.get("irc:#{irc}", 'sasl_password')[0]
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
      $m.events.on(self, 'irc:OnRaw1:CAP') do |irc, data|
        # LS
        if data[3] == 'LS'
          req = []
          data[4].sub!(/^:/, '')
          
          # Request multi-prefix.
          if data[4..-1].include? 'multi-prefix'
            req << 'multi-prefix'
          end

          # If we're supposed to be using SASL, request it.
          if $m.conf.get("irc:#{irc}", 'sasl') and data[4..-1].include? 'sasl'
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
            irc.sasl_id = $m.timers.spawn(irc, $m.conf.get("irc:#{irc}", 'sasl_timeout')[0], :once) do
              irc.snd('CAP END')
            end
          else
            irc.snd('CAP END')
          end
        end
      end

      # PING
      $m.events.on(self, 'irc:onRaw0:PING') do |irc, data|
        irc.snd("PONG #{data[1]}")
      end

      ### NUMERICS ###

      # 005
      $m.events.on(self, 'irc:OnRaw1:005') do |irc, data|

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
      
      # 903
      $m.events.on(self, 'irc:OnRaw1:903') do |irc, data|
        # SASL authentication was successful.
        $m.info("SASL authentication to #{irc} successful.")
        $m.timers.del(irc, irc.sasl_id)
        irc.sasl_id = nil
        irc.snd('CAP END')
      end

      # 904
      $m.events.on(self, 'irc:OnRaw1:904') do |irc, data|
        # SASL authentication failed.
        $m.info("SASL authentication to #{irc} failed.")
        $m.timers.del(irc, irc.sasl_id)
        irc.sasl_id = nil
        irc.snd('CAP END')
      end

    end # def init

  end # module Std

end # module IRC

# vim: set ts=4 sts=2 sw=2 et:
