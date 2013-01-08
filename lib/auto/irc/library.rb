# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'auto/irc/server'
require 'auto/irc/object/entity'
require 'auto/irc/object/channel'
require 'auto/irc/object/user'
require 'auto/irc/protocol'
require 'auto/irc/common'

module Auto
  
  module IRC
    
    # The base of the IRC framework.
    #
    # @!attribute [r] events
    #   @return [Auto::API::Events] The IRC event system.
    #
    # @!attribute [r] connections
    #   @return [Hash{String => Auto::IRC::Server}] Collection of IRC connections. 
    class Library

      attr_reader :events, :connections

      def initialize

        # Initialize our event system.
        @events      = Auto::API::Events.new
        # Prepare our collection of IRC server connections.
        @connections = Hash.new
      
        # Be ready to accept data.
        $m.events.on :net_receive, 1, &method(:receive)

        # Start connections when Auto is started.
        $m.events.on :start, &method(:start)

        # Prepare for incoming IRC traffic.
        prepare_incoming_traffic

        # Parse data.
        @parser = Auto::IRC::Protocol.new self

        # Handle common functions.
        @common = Auto::IRC::Common.new self
        
      end # def initialize

      # Process incoming network data.
      #
      # @param [Object] socket_object The socket object, which in the case of
      #   ourselves should be an {Auto::IRC::Server}, or we won't handle it.
      def receive socket_object
        if socket_object.instance_of? Auto::IRC::Server
          socket_object.recv   
        end
      end

      # Initiate IRC connections.
      def start
        
        # Iterate through each IRC server in the config, and connect to it.
        $m.conf['irc'].each do |name, hash|
          begin
            # Configure the IRC instance.
            @connections[name] = Auto::IRC::Server.new(name) do |c|
              c.address = hash['address']
              c.port    = hash['port']
              c.nick    = hash['nickname'][0] 
              c.user    = hash['username']
              c.real    = hash['realName']
              c.ssl     = hash['useSSL']
            end

            # Connect.
            $m.sockets << @connections[name]
            @connections[name].connect
          rescue => e
            $m.error("Connection to #{name} failed: #{e}", false, e.backtrace)
          end
        end

      end # def start

      #######
      private
      #######

      # Prepare for incoming IRC traffic.
      def prepare_incoming_traffic
        @events.on :net_receive do |irc|
          until irc.recvq.length == 0
            line = irc.recvq.shift.chomp
            $m.foreground("{irc-recv} #{irc} >> #{line}")
            @events.call :receive, irc, line # send it out to :receive
          end
        end
      end

    end # class Library

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
