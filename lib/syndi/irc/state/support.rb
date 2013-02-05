# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Syndi
  module IRC
    module State
      
      # A state-management class which records the various capabilities of the
      # IRC daemon.
      #
      # @!attribute connected
      #   @return [Boolean] Whether we are connected and registered.
      #
      # @!attribute cap
      #   @return [Array<String>] A list of enabled capabilities.
      #
      # @!attribute sasl_method
      #   @return [Symbol] Method of SASL authentication (+:plain+ or +:dh_blowfish+).
      #
      # @!attribute sasl_id
      #   @return [Array<String>] Identities of SASL-related timers.
      #
      # @!attribute server_name
      #   @return [String] Name of the server to which we are connected (e.g. asimov.freenode.net).
      #
      # @!attribute nicklen
      #   @return [Integer] The maximum length of a nickname permissible.
      #
      # @!attribute prefixes
      #   @return [Hash{Symbol => String}] The list of channel user prefixes supported.
      #
      # @!attribute chan_modes
      #   @return [Hash{Symbol => Array<Symbol>}] The list of channel modes supported. The keys
      #     are +:never+, +:list+, +:set+, and +:always+. List: list mode (e.g. +b). Never:
      #     never has a parameter. Set: has a parameter only when set. Always: always has a
      #     parameter.
      #
      # @!attribute modelen
      #   @return [Integer] The maximum number of modes permissible in a single /MODE.
      #
      # @!attribute topiclen
      #   @return [Integer] The maximum length of a /TOPIC permissible.
      #
      # @!attribute chanlen
      #   @return [Integer] The maximum length of a channel's name permissible.
      class Support

        attr_accessor :cap, :sasl_method, :sasl_id, :server_name, :nicklen, :prefixes,
                      :chan_modes, :modelen, :topiclen, :chanlen, :connected

        def initialize
          # hashes
          %w[chan_modes prefixes].each do |hsh|
            instance_variable_set("@#{hsh}", {})
          end
          # arrays
          %w[cap sasl_id].each do |arr|
            instance_variable_set("@#{arr}", [])
          end
          # strings/symbols/booleans/integers
          %w[sasl_method server_name nicklen topiclen modelen chanlen
             connected].each do |str|
            instance_variable_set("@#{str}", nil)
          end
        end

        # Process ISUPPORT data.
        #
        # @param [Syndi::IRC::Server] irc The IRC connection.
        # @param [String] data The ISUPPORT data string.
        def isupport irc, data
          
          # Nick, channel, topic, and mode length
          {'@nicklen'  => 'NICKLEN',
           '@chanlen'  => 'CHANNELLEN',
           '@topiclen' => 'TOPICLEN',
           '@modelen'  => 'MODES' }.each_pair do |var, indic|
            
            if data =~ /#{indic}=(\d+)/
              instance_variable_set(var, $1.to_i)
            end

          end

          # Parse channel modes.
          parse_channel_modes data

          # Parse prefixes.
          parse_prefixes data

        end

        #######
        private
        #######

        # Parse supported channel modes.
        #
        # @param [String] data The data string.
        def parse_channel_modes data
          if match = %r{\WCHANMODES=(\w+),(\w+),(\w+),(\w+)\W}.match(data)
            list   = match[1].split // || []
            always = match[2].split // || []
            set    = match[3].split // || []
            never  = match[4].split // || []

            list.map!   { |m| m.to_sym }
            always.map! { |m| m.to_sym }
            set.map!    { |m| m.to_sym }
            never.map!  { |m| m.to_sym }

            { list: list, always: always, set: set, never: never }
          end
        end

        # Parse supported prefixes.
        #
        # @param [String] data The data string.
        def parse_prefixes data
          if match = %r{\WPREFIX=\((\w+)\)(\W+)\s}.match(data)
            modes    = match[1].split //
            prefixes = match[2].split //
            
            modes.map! { |m| m.to_sym }

            i = 0
            modes.each do |m|
              @prefixes[m] = prefixes[i]
              i += 1
            end
          end
        end

      end # class Support

    end # module State

  end # module IRC

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
