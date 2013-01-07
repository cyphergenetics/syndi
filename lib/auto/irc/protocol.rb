# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'auto/irc/std/numerics'

# namespace Auto
module Auto

  # namespace IRC
  module IRC

    class Protocol
      include Auto::IRC::Std::Numerics

      # Construct a new IRC data parser.
      #
      # @param [Auto::IRC::Library] lib The IRC library instance.
      def initialize(lib)
        lib.events.on :receive, &method(:parse)
      end
        
      # Parse IRC data.
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [String] raw The data received.
      def parse(irc, raw)
          
        params  = raw.split(/\s+/)
        command = (raw =~ /^:/ ? params[1] : params[0]).dc

        # Check if we process this command.
        if respond_to? "on_#{command.dc}"
          send("on_#{command.dc}", irc, raw, params)
        end

      end
        
      # CAP
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      # @param [String] raw The data received.
      # @param [Array<String>] params The data received divided by +\s+ through
      #   regexp.
      def on_cap(irc, raw, params)
        case params[3]

        # CAP LS
        # Currently, Auto's capabilities include the multi-prefix, sasl,
        # account-notify, away-notify, and extended-join extensions.
        when 'LS'
          req = []
          params[4].gsub!(/^:/, '')

          # Every extension possible will be used except SASL, which requires
          # special configuration.
          %w[multi-prefix account-notify away-notify extended-join].each do |ext|
            req.push ext if params[4..-1].include? ext
          end

          if $m.conf['irc'][irc.s]['SASL'] and params[4..-1].include? 'sasl'
            req.push 'sasl'
          end

          # Send CAP REQ.
          irc.snd("CAP REQ :#{req.join(' ')}") unless req.empty?

        # CAP ACK
        # We must save all capabilities into +irc.supp.cap+, and initiate SASL
        # if possible.
        when 'ACK'
          params[4].gsub!(/^:/, '')
          irc.supp.cap = params[4..-1]
          
          if irc.supp.cap.include? 'sasl'
            # SASL stuff goes here
          else
            irc.snd('CAP END') # end capability negotiation and complete registration
          end

        end
      end

    end # class Protocol

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
