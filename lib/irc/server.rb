# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

require 'socket'
require 'openssl'

#############################################################################
# IRC::Server
#
# A class which maintains a connection to an IRC server and provides a highly
# usable interface for the IRC server.
#############################################################################

# Entering namespace: IRC
module IRC

  # Class Server: A connection to an IRC server.
  class Server

    attr_reader :socket, :in, :out
    attr_accessor :name, :address, :port, :nick, :user, :real, :password,
                  :bind, :ssl, :sasl_id, :connected, :mask, :recvq,
                  :mask, :prefixes, :channel_modes, :max_modes,
                  :await_self_who

    # Create a new instance of IRC::Server.
    # (str)
    def initialize(name)
      
      # Prepare attributes.
      @name     = name
      @address  = nil
      @port     = nil
      @nick     = nil
      @user     = nil
      @real     = nil
      @password = nil
      @bind     = nil
      @ssl      = false

      # Yield for configuration.
      yield(self) if block_given?

      # Additional instance attributes.
      @in        = 0
      @out       = 0
      @socket    = nil
      @connected = false

      # Stateful attributes.
      @mask           = ''
      @prefixes       = {}
      @channel_modes  = { list: [], always: [], set: [], never: [] }
      @max_modes      = 0
      @await_self_who = false

      # Our recvQ.
      @recvq  = []
      @recvqm = ''

      # Default handlers.
      bind_default_handlers

    end

    ### BASIC ###

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
      $m.events.call('irc:onPreConnect', self)
      pass(@password) if @password
      snd('CAP LS')
      chgnick(@nick)
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
      recv, data = data.split(/(?<=\r\n)/, 2)

      # Check if there's a remainder in the recvQ.
      if @recvqm != ''
        recv[0] = "#@recvqm#{recv[0]}"
        @recvqm = ''
      end
      @recvqm = data if data != ''

      # Lastly, push the data to the recvQ and call irc:onReadReady.
      @recvq.push(*recv)
      $m.events.call('irc:onReadReady', self)

    end

    ### INTERFACE ###

    # Disconnect from the server.
    def disconnect(msg='Closing connection')
      $m.events.call('irc:onDisconnect', self)
      snd("QUIT :#{msg}")
    end
      
    # Join a channel.
    # (str, [str])
    def join(chan, key=nil)
      $m.events.call('irc:onBotPreOutJoin', self, chan, key)
      snd("JOIN #{chan}#{key.nil? ? '' : key}")
      $m.events.call('irc:onBotOutJoin', self, chan, key)
    end

    # Change nickname.
    # (str)
    def chgnick(newnick)
      if connected?
        @newnick = newnick
      else
        @nick = newnick
      end
      
      $m.events.call('irc:onBotPreOutNick', self, newnick)
      snd("NICK :#{newnick}")
      $m.events.call('irc:onBotOutNick', self, newnick)
    end

    # Part a channel.
    # (str, [str])
    def part(chan, msg='Leaving')
      $m.events.call('irc:onSelfPrePart', self, chan, msg)
      snd("PART #{chan} :#{msg}")
      $m.events.call('irc:onSelfPart', self, chan, msg)
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
      $m.events.call('irc:onPreWho', self, target)
      snd("WHO #{target}")
      $m.events.call('irc:onWho', self, target)
    end

    ### STATE ###

    # Create a user.
    #
    def new_user(nickname, username=nil, hostname=nil, away=false)
      
      # Check if this user already exists, and if so, issue a warning
      # and update the already-existing user's data.
      if user_known? nickname.lc
        $m.warn("Attempted to introduce user #{nickname}, but user is already known. Updating current data in lieu...")
        @users[nickname.lc].update(nickname, username, hostname, away)
      end



    # Check with a user's existence is known to the IRC state management.
    def user_known?(nickname)
      @users.include?(nickname.lc) ? true : false
    end

    ### RUBY ###

    # How we appear in string form.
    # ()
    def to_s
      @name
    end
    def s
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
      $m.events.on(self, 'irc:onRaw1:001') do |irc, data|

        if irc == self
          
          # Connection established.
          $m.info("Successfully connected to #@name!")
          @connected = true
          
          # First event.
          $m.events.call('irc:onPreProcessConnect', self)
          
          # Identify the traditional way.
          if $m.conf.x['irc'][irc.s].include?('nickIdentify')
            msg($m.conf.x['irc'][irc.s]['nickIdentify']['service'], 
                "#{$m.conf.x['irc'][irc.s]['nickIdentify']['command']} #{$m.conf.x['irc'][irc.s]['nickIdentify']['password']}")
          end
          
          # Send a WHO on ourselves.
          who(@nick)
          @await_self_who = true
          
          # Join any channels specified in the configuration.
          if $m.conf.x['irc'][irc.s].include?('autojoin')
            $m.conf.x['irc'][irc.s]['autojoin'].each { |c| join(c['name'], c['key']) }
          end

          # Final event.
          $m.events.call('irc:onPostProcessConnect', self)
        end
      
      end

    end

  end # class Server

end # module IRC

# vim: set ts=4 sts=2 sw=2 et:
