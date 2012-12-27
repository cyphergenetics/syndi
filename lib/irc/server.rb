# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.
require 'socket'
require 'openssl'

# Entering namespace: IRC
module IRC

  # A class which maintains a connection to an IRC server and provides a highly
  # usable interface for the IRC server.
  #
  # @api IRC
  # @since 4.0.0
  # @author noxgirl
  #
  # @!attribute [r] socket
  #   @return [TCPSocket] The TCP socket being used for the connection.
  #
  # @!attribute [r] in
  #   @return [Integer] The number of bytes received from the socket.
  #
  # @!attribute [r] out
  #   @return [Integer] The number of bytes sent to the socket.
  #
  #
  # @!attribute name
  #   @return [String] The name of the server as specified by configuration.
  #
  # @!attribute address
  #   @return [String] The address used to connect to the server.
  #
  # @!attribute port
  #   @return [Integer] The port used to connect to the server
  #
  # @!attribute nick
  #   @return [String] The nickname of the bot on the server.
  #
  # @!attribute user
  #   @return [String] The username of the bot on the server.
  #
  # @!attribute real
  #   @return [String] The real name or GECOS of the bot on the server.
  #
  # @!attribute password
  #   @return [String] If needed, the password used to connect to the server
  #   @return [nil] If not needed.
  #
  # @!attribute bind
  #   @return [String] If desired, the address to which to bind for this socket
  #   @return [nil] If not desired.
  #   @note This appears to be unused at the moment.
  #
  # @!attribute ssl
  #   @return [true, false] If SSL should [not] be used for the connection.
  #
  # @!attribute sasl_id
  #   @return [String] If SASL is desired, the username with which to authenticate.
  #   @return [nil] If not used.
  #   @note This is seemingly deprecated?
  #
  # @!attribute connected
  #   @return [true, false] Whether or not we are connected to the server.
  #
  # @!attribute mask
  #   @return [String] The bot's own hostname or mask on the IRC server.
  #
  # @!attribute recvq
  #   @return [Array<String>] The socket's receive queue, which is comprised of an array
  #     of strings which are pending processing.
  #
  #
  # @!attribute prefixes
  #   @return [Hash{String => String}] The IRC server's supported prefixes, with the key being
  #     the channel mode which represents the prefix, and the value being the prefix.
  #
  # @!attribute channel_modes
  #   @return [Hash{Symbol => Array<String>}] The IRC server's supported channel modes, divided as thus:
  #
  #     - +:list+   = A list of modes which add/remove a nickname or mask from a channel list, such as ops and bans.
  #     - +:always+ = A llst of modes which change a channel setting, and always have a parameter.
  #     - +:set+    = A list of modes which change a channel setting, and which have a parameter only when set.
  #     - +:never+ = A list of modes which change a channel setting, and which never have a parameter.
  #
  # @!attribute max_modes
  #   @return [Integer] The maximum number of mode changes which may be specified in a /MODE query.
  #
  # @!attribute await_self_who
  #   @return [true, false] Whether or not we are awaiting for a response to a /WHO on ourselves.
  #
  # @!attribute channels
  #   @return [Hash{String => IRC::Object::Channel}] A list of channels in which we reside,
  #     with each key being the channel's name in all-lowercase, and the respective values
  #     being of {IRC::Object::Channel IRC::Object::Channel}.
  #
  # @!attribute users
  #   @return [Hash{String => IRC::Object::User}] A list of users who are known to us,
  #     with each key being the user's nickname in all-lowercase, and the respective values
  #     being of {IRC::Object::User IRC::Object::User}.
  class Server

    attr_reader :socket, :in, :out
    attr_accessor :name, :address, :port, :nick, :user, :real, :password,
                  :bind, :ssl, :sasl_id, :connected, :mask, :recvq,
                  :prefixes, :channel_modes, :max_modes,
                  :await_self_who, :channels, :users

    # Produce a new instance of {IRC::Server}.
    #
    # @param [String] name The name of the server to which we should connect.
    #
    # @yieldparam [IRC::Server] c This instance, intended for configuration of the
    #   attributes.
    #
    # Configuration attributes are +address+, +port+, +nick+, +user+, +real+,
    # +password+, +bind+, and +ssl+.
    #
    #
    # @example
    #   irc = IRC::Server.new('Freenode') do |c|
    #     c.address = 'irc.freenode.net'
    #     c.port    = 7000
    #     c.nick    = 'cowmoon'
    #     c.user    = 'foo1'
    #     c.real    = "The night is lovely."
    #     c.bind    = 'localhost'
    #     c.ssl     = true
    #   end
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
      yield(self) if block_given? or raise ArgumentError, "IRC::Server unable to initialize because it was not configured."

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
      @channels       = {}
      @users          = {}

      # Our recvQ.
      @recvq  = []
      @recvqm = ''

      # Default handlers.
      bind_default_handlers

    end

    ### BASIC ###

    # Establish (or attempt to) a connection with the server.
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
      nickname = @nick
      user(@user, Socket.gethostname, @address, @real)

    end

    # Send data to the socket.
    #
    # @param [String] data The string of data, which should not exceed 512 in length.
    def snd(data)
      $m.foreground("#@name << #{data}")
      @socket.write("#{data}\r\n")
      @out += "#{data}\r\n".length
    end

    # Receive data from the socket, and push it into the recvQ.
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
    #
    # @param [String] msg Reason for disconnect. 
    def disconnect(msg='Closing connection')
      $m.events.call('irc:onDisconnect', self, msg)
      snd "QUIT :#{msg}"
    end
      
    # Join a channel on the server.
    #
    # @param [String] chan Channel to join.
    # @param [String] key Key to join, if necessary.
    def join(chan, key=nil)
      $m.events.call('irc:onPreJoin', self, chan, key)
      snd "JOIN #{chan}#{key.nil? ? '' : key}"
      $m.events.call('irc:onJoin', self, chan, key)
    end

    # Send /NICK to change the bot's nickname on the server.
    #
    # @note If the nickname is in use, the bot will append a hyphen and retry,
    #   repeating until success is achieved.
    #
    # @param [String] new The new nickname.
    def nickname=(new)

      if connected?
        @newnick = new
      else
        @nick = new
      end
      
      $m.events.call('irc:onPreNick', self, new)
      snd "NICK :#{new}"
      $m.events.call('irc:onNick', self, new)
    
    end

    # Supply server password.
    #
    # @param [String] pass
    def pass(password); snd "PASS :#{password}"; end

    # Send /USER.
    #
    # @param [String] username The bot's username or ident.
    # @param [String] hostname The bot's hostname.
    # @param [String] server Address of the remote server.
    # @param [String] realname The bot's real name or GECOS.
    def user(username, hostname=Socket.gethostname, server, realname)
      snd "USER #{username} #{hostname} #{server} :#{realname}"
    end

    # Request a /WHO on ourselves.
    def who
      snd("WHO #@nick")
      @await_self_who = true
      $m.events.call('irc:onWhoSelf', self)
    end

    ### STATE ###

    # Introduce a new user.
    #
    # @param [String] nickname The nickname of the user.
    # @param [String] username The username or ident of the user.
    # @param [String] hostname The hostname or mask of the user.
    # @param [true, false] Whether the user is away.
    def new_user(nickname, username=nil, hostname=nil, away=false)
      
      # Check if this user already exists, and if so, issue a warning
      # and update the already-existing user's data.
      if user_known? nickname
        
        $m.warn("Attempted to introduce user #{nickname}, but user is already known. Updating current data in lieu...")
        @users[nickname.lc].nick = nickname
        @users[nickname.lc].user = username
        @users[nickname.lc].host = hostname
        @users[nickname.lc].away = away
      
      else
        
        # Create the user.
        u = IRC::Object::User.new(irc, nickname, username, hostname, away)
        @users[nickname.lc] = u
        $m.events.call('irc:introduceUser', u)

        # Request more data if needed.
        if not u.host_known?
          u.who
        end

      end

    end

    # Check if a user's existence is known to the IRC state management.
    #
    # @param [String] nickname
    #
    # @return [true, false]
    def user_known?(nickname)
      @users.include?(nickname.lc) ? true : false
    end

    ### RUBY ###

    def to_s; @name; end
    def s; @name; end
    def inspect; "#<IRC::Server: #@name>"; end

    #######
    private
    #######

    # Check the presence of all attributes.
    def attribute_check
      raise(Error, "Missing server address")  unless @address
      raise(Error, "Missing server port")     unless @port
      raise(Error, "Missing nickname to use") unless @nick
      raise(Error, "Missing username to use") unless @user
      raise(Error, "Missing realname to use") unless @real
    end

    # Check if we are connected.
    #
    # @return [true, false]
    def connected?
      return false unless @socket
      return false unless @connected
      true
    end

    # Bind default handlers.
    #
    # - RPL_WELCOME (005)
    #
    # @todo Make the traditional method of identifying with services use the
    #   new API model, since the old one is deprecated.
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
          
          # Send a /WHO on ourselves.
          who
          
          # Join any channels specified in the configuration.
          if $m.conf.x['irc'][irc.s].include?('autojoin')
            $m.conf.x['irc'][irc.s]['autojoin'].each { |c| join(c['name'], c['key']) }
          end

          # Final event.
          $m.events.call('irc:onPostProcessConnect', self)
        
        end # if irc == self
      
      end # on RPL_WELCOME

    end # def bind_default_handlers

  end # class Server

end # module IRC

# vim: set ts=4 sts=2 sw=2 et:
