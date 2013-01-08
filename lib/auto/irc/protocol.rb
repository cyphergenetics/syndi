# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'auto/irc/protocol/numerics'

# namespace Auto
module Auto

  # namespace IRC
  module IRC
    autoload :SASL, 'auto/irc/sasl/mech'

    # A class for parsing of data per the specifications of the IRC protocol,
    # v3.1.
    #
    # @see http://tools.ietf.org/html/rfc1459
    # @see http://ircv3.atheme.org/
    #
    # @since 4.0.0
    class Protocol

      # Construct a new IRC data parser.
      #
      # @param [Auto::IRC::Library] lib The IRC library instance.
      def initialize lib
        extend Auto::IRC::Protocol::Numerics
        lib.events.on :receive, &method(:parse)
      end
        
      # Parse IRC data.
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [String] raw The data received.
      def parse irc, raw
          
        params  = raw.split(/\s+/)
        command = (raw =~ /^:/ ? params[1] : params[0]).dc

        # Check if we process this command.
        if respond_to? "on_#{command}"
          send("on_#{command}", irc, raw, params)
        end

      end

      # AUTHENTICATE
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [String] raw The data received.
      # @param [Array<String>] params The data received divided by +\s+ through
      #   regexp.
      def on_authenticate irc, raw, params
        username = $m.conf['irc'][irc.s]['SASL']['username']
        password = $m.conf['irc'][irc.s]['SASL']['password']
        
        if irc.supp.sasl_method    == :dh_blowfish
          crypt = Auto::IRC::SASL::Mech::DHBlowfish.encrypt(username, password, params.last)
        elsif irc.supp.sasl_method == :plain
          crypt = Auto::IRC::SASL::Mech::Plain.encrypt(username, password, params.last)
        end

        while crypt.length >= 400
          irc.snd "AUTHENTICATE #{crypt.slice!(0, 400)}"
        end

        if crypt.length > 0
          irc.snd "AUTHENTICATE #{crypt}"
        else
          irc.snd('AUTHENTICATE +')
        end
        # And we're done!
      end
        
      # CAP
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [String] raw The data received.
      # @param [Array<String>] params The data received divided by +\s+ through
      #   regexp.
      def on_cap irc, raw, params
        case params[3]

        when 'LS'
          params[4].gsub!(/^:/, '')
          cap_ls(irc, params[4..-1])
        when 'ACK'
          params[4].gsub!(/^:/, '')
          cap_ack(irc, params[4..-1])
        end
      end

      # PING
      #
      # Return a PONG.
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [String] raw The data received.
      # @param [Array<String>] params The data received divided by +\s+ through
      #   regexp.
      def on_ping irc, raw, params
        irc.snd("PONG #{params[1]}")
      end

      #######
      private
      #######

      # CAP LS
      #  
      # Currently, Auto's capabilities include the multi-prefix, sasl,
      # account-notify, away-notify, and extended-join extensions.
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [Array<String>] list List of capabilities.
      def cap_ls irc, list

        req = []
          
        # Every extension possible will be used except SASL, which requires
        # special configuration.
        %w[multi-prefix account-notify away-notify extended-join].each do |ext|
          req.push ext if list.include? ext
        end

        if $m.conf['irc'][irc.s]['SASL'] and list.include? 'sasl'
          req.push 'sasl'
        end

        # Send CAP REQ.
        irc.snd("CAP REQ :#{req.join(' ')}") unless req.empty?

      end
      
      # CAP ACK
      #
      # We must save all capabilities into +irc.supp.cap+, and initiate SASL
      # if possible.
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [Array<String>] list List of capabilities.
      def cap_ack irc, list

        irc.supp.cap = list
          
        if list.include? 'sasl'
          irc.supp.sasl_id << $m.clock.spawn($m.conf['irc'][irc.s]['SASL']['timeout']||10, :once, irc) do |s|
            $m.error "SASL authentication on #{s} failed: authentication procedure timed out."
            s.snd('AUTHENTICATE *')
            s.cap_end
          end
          irc.authenticate :dh_blowfish
        else
          irc.snd('CAP END') # end capability negotiation and complete registration
        end

      end

    end # class Protocol

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
