# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/irc/client'

describe Syndi::IRC::Client do

  describe '#new' do
    
    it 'creates a new IRC connection' do
      
      with_tcp_serv do |address, port, server|
        irc = Syndi::IRC::Client.new('meownet') do |c|
          c.address = address
          c.port    = port
          c.nick    = 'cows'
          c.user    = 'foobar'
          c.real    = 'Your father'
          c.ssl     = false
        end
        irc.connect
        expect(server.buffer).to eq "CAP LS\r\nNICK :cows\r\nUSER foobar #{Socket.gethostname} #{address} :Your father\r\n"
      end
    
    end

    it 'and supports SSL' do
      pending 'whilst SSL client support is implemented, the testing server is broken'
      with_tcp_serv(true, port: 7885) do |address, port, server|
        irc = Syndi::IRC::Client.new('meownet') do |c|
          c.address = address
          c.port    = port
          c.nick    = 'cows'
          c.user    = 'foobar'
          c.real    = 'Your father'
          c.ssl     = true
        end
        irc.connect
        expect(server.buffer).to eq "CAP LS\r\nNICK :cows\r\nUSER foobar #{Socket.gethostname} #{address} :Your father\r\n"
      end
    end
  
  end

end

# vim: set ts=4 sts=2 sw=2 et:
