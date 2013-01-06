# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'irc/server'
require 'irc/object/entity'
require 'irc/object/channel'
require 'irc/object/user'

module Auto
  
  module IRC
    
    # The base of the IRC framework.
    class Library

      def initialize
        
      end
      
      # Check if the irc core library is loaded.
      if @libs.include?('irc')
        # Prepare for incoming data.
        $m.events.on(self, 'irc:onReadReady') do |irc|
          until irc.recvq.length == 0
            line = irc.recvq.shift.chomp
            foreground("#{irc} >> #{line}")
            @irc_parser.parse(irc, line)
          end
        end
        
        # Iterate through each IRC server in the config, and connect to them.
        @conf.x['irc'].each do |name, hash|
          begin
            # Configure the IRC instance.
            @irc_sockets[name] = IRC::Server.new(name) do |c|
              c.address = hash['address']
              c.port    = hash['port']
              c.nick    = hash['nickname'][0] 
              c.user    = hash['username']
              c.real    = hash['realName']
              c.ssl     = hash['useSSL']
            end

            # Connect.
            @irc_sockets[name].connect
          rescue => e
            error("Connection to #{name} failed: #{e}", false, e.backtrace)
          end
        end
      end

    end

  end

end

# vim: set ts=4 sts=2 sw=2 et:
