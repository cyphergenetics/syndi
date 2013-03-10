# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/events'
require 'syndi/irc/client'
require 'syndi/irc/object/entity'
require 'syndi/irc/object/channel'
require 'syndi/irc/object/user'
require 'syndi/irc/protocol'
require 'syndi/irc/common'

module Syndi
  module IRC
    
    # The base of the IRC framework.
    #
    # @!attribute [r] events
    #   @return [Syndi::API::Events] The IRC event system.
    #
    # @!attribute [r] networks
    #   @return [Hash{String => Syndi::IRC::Client}] Collection of IRC connections. 
    class Library

      attr_reader :events, :networks

      def initialize

        # Initialize our event system.
        @events   = Syndi::Events.new
        # Prepare our collection of IRC server connections.
        @networks = Hash.new
      
        # Start connections when Syndi is started.
        Syndi.events.on :start, &method(:start)

        # Parse data.
        @parser = Syndi::IRC::Protocol.new self

        # Handle common functions.
        @common = Syndi::IRC::Common.new self
        
      end # def initialize

      # Initiate IRC connections.
      def start
        
        # Iterate through each IRC server in the config, and connect to it.
        Syndi.conf['irc'].each do |name, hash|
          begin
            # Configure the IRC instance.
            @networks[name] = Syndi::IRC::Client.new(name) do |c|
              c.address = hash['address']
              c.port    = hash['port']
              c.nick    = hash['nickname'][0] 
              c.user    = hash['username']
              c.real    = hash['realName']
              c.ssl     = hash['useSSL']
            end

            # Connect.
            @networks[name].connect
          rescue => e
            Syndi.log.error "Connection to #{name} failed: #{e}", true
          end
        end

      end # def start

    end # class Library
  end # module IRC
end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
