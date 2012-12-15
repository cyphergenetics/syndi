# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

require 'socket'
require 'openssl'

# Entering namespace: IRC
module IRC

  # Class Server: A connection to an IRC server.
  class Server

    attr_reader :socket, :in, :out
    attr_accessor :name, :address, :port, :nick, :user, :real, :pass,
                  :bind, :ssl, :sasl_id, :connected, :mask, :recvq,
                  :mask, :prefixes, :channel_modes, :max_modes

    # Create a new instance of IRC::Server.
    # (str)
    def initialize(name)
      
      # Prepare attributes.
      @name    = name
      @address = nil
      @port    = nil
      @nick    = nil
      @user    = nil
      @real    = nil
      @pass    = nil
      @bind    = nil
      @ssl     = false

      # Yield for configuration.
      yield(self) if block_given?

      # Additional instance attributes.
      @in        = 0
      @out       = 0
      @socket    = nil
      @connected = false

      # Stateful attributes.
      @mask          = ''
      @prefixes      = {}
      @channel_modes = { list: [], always: [], set: [], never: [] }
      @max_modes     = 0

      # Our recvQ.
      @recvq  = []
      @recvqm = ''

      # Default handlers.
      bind_default_handlers

    end

    # Connect to the remote server.
    # ()
    def connect

      # Check for missing attributes.
      begin
        attribute_check
      rescue => e
        $m.error("Cannot connect to server #@name: #{e}", false, e.backtrace)
      end

      $m.info("Connecting to #@name @ #@address:#@port...")

      # Create a new socket.
      begin
        socket = TCPSocket.new(@address, @port, @bind)
      rescue => e
        $m.error("Failed to connect to server #@name: #{e}", false, e.backtrace)
        raise
      end

      # Wrap it in SSL if told to.
      if ssl
        begin
          socket = OpenSSL::SSL::SSLSocket.new(socket)
          socket.connect
        rescue => e
          $m.error("Failed to connect to server #@name: #{e}", false, e.backtrace)
          raise
        end
      end

      @socket = socket

      # Register.
      $m.events.call('Irc.OnPreConnect', self)
      pass(@pass) if @pass
      snd('CAP LS')
      nick(@nick)
      user(@user, Socket.gethostname, @address, @real)

    end

    # Send data to the socket.
    # (str)
    def snd(data)
      $m.foreground("#@name << #{data}")
      @socket.write("#{data}\r\n")
      @out += "#{data}\r\n".length
    end

    # Receive data from the socket.
    # ()
    def recv

      # Read the data.
      data = @socket.sysread(1024)
      # Increase in.
      @in += data.length
      
      # Split the data.
      recv = data.scan(/(.+\r\n)/)
      data.gsub!(/(.+\r\n)/, '')
      recv.flatten!

      # Check if there's a remainder in the recvQ.
      if @recvqm != ''
        recv[0] = "#@recvqm#{recv[0]}"
        @recvqm = ''
      end
      @recvqm = data if data != ''

      # Lastly, push the data to the recvQ and call Irc.OnReadReady.
      @recvq.push(*recv)
      $m.events.call('Irc.OnReadReady', self)

    end
      
    # Join a channel.
    # (str, [str])
    def join(chan, key=nil)
      $m.events.call('Irc.OnBotPreOutJoin', self, chan, key)
      snd("JOIN #{chan}#{key.nil? ? '' : key}")
      $m.events.call('Irc.OnBotOutJoin', self, chan, key)
    end

    # Change nickname.
    # (str)
    def nick(newnick)
      if connected?
        @newnick = newnick
      else
        @nick = newnick
      end
      
      $m.events.call('Irc.OnBotPreOutNick', self, newnick)
      snd("NICK :#{newnick}")
      $m.events.call('Irc.OnBotOutNick', self, newnick)
    end

    # Send a message.
    # (str, str)
    def msg(target, message)
      $m.events.call('Irc.OnBotPreMsg', self, target, message)
      snd("PRIVMSG #{target} :#{message}")
      $m.events.call('Irc.OnBotMsg', self, target, message)
    end

    # Send a notice.
    # (str, str)
    def notice(target, message)
      $m.events.call('Irc.OnBotPreNotice', self, target, message)
      snd("NOTICE #{target} :#{message}")
      $m.events.call('Irc.OnBotNotice', self, target, message)
    end

    # Part a channel.
    # (str, [str])
    def part(chan, msg='Leaving')
      $m.events.call('Irc.OnBotPreOutPart', self, chan, msg)
      snd("PART #{chan} :#{msg}")
      $m.events.call('Irc.OnBotPrePart', self, chan, msg)
    end

    # Supply server password.
    # (str)
    def pass(password)
      snd("PASS :#{password}")
    end

    # Send USER.
    # (str, str, str, str)
    def user(username, hostname, server, realname)
      snd("USER #{username} #{hostname} #{server} :#{realname}")
    end

    # Send a WHO.
    # (str)
    def who(target)
      $m.events.call('Irc.OnPreWho', self, target)
      snd("WHO #{target}")
      $m.events.call('Irc.OnWho', self, target)
    end

    # How we appear in string form.
    # ()
    def to_s
      @name
    end

    #######
    private
    #######

    # Check the presence of all attributes.
    # ()
    def attribute_check
      raise(Error, "Missing server address")  unless @address
      raise(Error, "Missing server port")     unless @port
      raise(Error, "Missing nickname to use") unless @nick
      raise(Error, "Missing username to use") unless @user
      raise(Error, "Missing realname to use") unless @real
    end

    # Check if we are connected.
    # () -> bool
    def connected?
      Return false unless @socket
      return false unless @connected
      true
    end

    # Bind default handlers.
    # ()
    def bind_default_handlers

      # RPL_WELCOME
      $m.events.on(self, 'Irc.OnRaw1_001') do |irc, data|

        if irc == self
          # Connection established.
          $m.info("Successfully connected to #@name!")
          @connected = true
          # First event.
          $m.events.call('Irc.OnPreProcessConnect', self)
          # Send identify-msg if given.
          if msg = $m.conf.get("irc:#@name", 'identify-msg')
            snd(msg[0])
          end
          # Send a WHO on ourselves.
          who(@nick)
          # Join any channels.
          if chans = $m.conf.get("irc:#@name", 'ajoin')
            chans.each do |chan|
              # Check for a key.
              key = nil
              if /\s/ =~ chan
                chan, key = chan.split(/\s+/)
              end
              # Send the join.
              join(chan, key)
            end
          end
          # Final event.
          $m.events.call('Irc.OnPostProcessConnect', self)
        end
      
      end

    end

  end # class Server

end # module IRC

# vim: set ts=4 sts=2 sw=2 et:
