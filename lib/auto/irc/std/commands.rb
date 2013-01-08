# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto

  module IRC

    module Std
    
      # A module which provides a number of methods for basic IRC commands,
      # intended for inclusion in {Auto::IRC::Server}.
      module Commands
      
        # Send initial AUTHENTICATE.
        def authenticate method = :plain
          if method    == :plain
            snd 'AUTHENTICATE PLAIN'
            @supp.sasl_method = :plain
          elsif method == :dh_blowfish
            snd 'AUTHENTICATE DH-BLOWFISH'
            @supp.sasl_method = :dh_blowfish
          end
        end

        # Send CAP END.
        def cap_end
          # Stop any SASL-related timers
          @supp.sasl_id.each { |t| $m.clock.del t }
          # Send CAP END
          snd 'CAP END'
        end

        # Disconnect from the server.
        #
        # @param [String] msg Reason for disconnect. 
        def disconnect msg = 'Closing connection'
          emit :irc, :disconnect, self, msg
          snd "QUIT :#{msg}"
          @socket = nil
        end
      
        # Join a channel on the server.
        #
        # @param [String] chan Channel to join.
        # @param [String] key Key to join, if necessary.
        def join chan, key = nil
          snd "JOIN #{chan}#{key.nil? ? '' : key}"
          emit :irc, :send_join, self, chan, key
        end

        # Send /NICK to change the bot's nickname on the server.
        #
        # @note If the nickname is in use, the bot will append a hyphen and retry,
        #   repeating until success is achieved.
        #
        # @param [String] new The new nickname.
        def nickname= new

          if connected?
            @newnick = new
          else
            @nick = new
          end
      
          snd "NICK :#{new}"
          emit :irc, :send_nick, self, new
    
        end

        # Supply server password.
        #
        # @param [String] pass
        def pass password; snd "PASS :#{password}"; end

        # Send /USER.
        #
        # @param [String] username The bot's username or ident.
        # @param [String] hostname The bot's hostname.
        # @param [String] server Address of the remote server.
        # @param [String] realname The bot's real name or GECOS.
        def user username, hostname=Socket.gethostname, server, realname
          snd "USER #{username} #{hostname} #{server} :#{realname}"
        end

        # Request a /WHO on ourselves.
        def who
          snd "WHO #@nick"
          emit :irc, :who_self, self
        end

      end # module Commands

    end  # module Std

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
