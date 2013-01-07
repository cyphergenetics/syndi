# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto
  module IRC
    module State
      
      # A state-management class which records the various capabilities of the
      # IRC daemon.
      #
      # @!attribute cap
      #   @return [Array<String>] A list of enabled capabilities.
      # @!attribute sasl_method
      #   @return [Symbol] Method of SASL authentication (+:plain+ or +:dh_blowfish+).
      # @!attribute sasl_id
      #   @return [Array<String>] Identities of SASL-related timers.
      # @!attribute server_name
      #   @return [String] Name of the server to which we are connected (e.g. asimov.freenode.net).
      # @!attribute nicklen
      #   @return Integer The maximum length of a nickname permissible.
      class Support

        attr_accessor :cap, :sasl_method, :sasl_id, :server_name, :nicklen

        def initialize
          # arrays
          %w[cap sasl_id].each do |arr|
            instance_variable_set("@#{arr}", [])
          end
          # strings/symbols
          %w[sasl_method server_name nicklen].each do |str|
            instance_variable_set("@#{str}", nil)
          end
        end

        # Process ISUPPORT data.
        #
        # @param [Auto::IRC::Server] irc The IRC connection.
        # @param [String] data The ISUPPORT data string.
        def isupport irc, data
          
          # Nick length.
          if data =~ /NICKLEN=(\d+)/
            @nicklen = $0.to_i
          end

          #

        end

      end # class Support

    end # module State

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
