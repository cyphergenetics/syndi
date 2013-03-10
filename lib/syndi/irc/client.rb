# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'ostruct'
require 'celluloid/io'
require 'syndi/dsl/base'
require 'syndi/irc/state/support'
require 'syndi/irc/std/commands'
require 'syndi/logging'
require 'syndi/talk/object'

module Syndi
  module IRC

    # A class which maintains a connection to an IRC server and provides a highly
    # usable interface for the IRC server.
    #
    # @api IRC
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
    # @!attribute [r] type
    #   @return [Symbol] +:irc+
    #
    # @!attribute [r] supp
    #   @return [Syndi::IRC::State::Support] The IRCd capabilities.
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
    #  @!attribute prefixes
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
    class Client
      include Syndi::DSL::Base
      include Celluloid::IO
      include Syndi::Logging
      prepend Syndi::Talk::Object

      attr_reader   :socket, :in, :out, :type, :supp
      attr_accessor :name, :address, :port, :nick, :user, :real, :password,
                    :bind, :ssl, :connected, :chans, :users

      # Produce a new instance of {Syndi::IRC::Client}.
      #
      # @param [String] name The name of the server to which we should connect.
      #
      # @yieldparam [Syndi::IRC::Client] c This instance, intended for configuration of the
      #   attributes.
      #
      # Configuration attributes are +address+, +port+, +nick+, +user+, +real+,
      # +password+, +bind+, and +ssl+.
      #
      #
      # @example
      #   irc = Syndi::IRC::Client.new('Freenode') do |c|
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
        yield self if block_given? or raise ArgumentError, "Server #{name} unable to initialize because it was not configured."

        # Additional instance attributes.
        @in         = 0
        @out        = 0
        @socket     = nil
        @connected  = false
        @type       = :irc

        # Pull in commands.
        extend   Syndi::IRC::Std::Commands
        # State managers.
        @supp  = Syndi::IRC::State::Support.new
        @chans = nil
        @users = nil

      end

      # Establish (or attempt to) a connection with the server.
      def connect

        # Check for missing attributes.
        begin
          attribute_check
        rescue => e
          error "Cannot connect to server #@name: #{e}", true
        end

        info "Connecting to #@name @ #@address:#@port..."

        # Create a new socket.
        begin
          @socket = TCPSocket.new(@address, @port, @bind)
          @socket = SSLSocket.new(@socket) if ssl
          
          # Register.
          emit :irc, :preconnect, self
          pass @password if @password
          snd 'CAP LS'
          self.nickname = @nick
          user @user, Socket.gethostname, @address, @real
        rescue => e
          error "Failed to connect to server #@name: #{e}", true
          raise
        end

        async.run

      end

      # Send data to the socket.
      #
      # @param [String] data The string of data, which should not exceed 512 in length.
      def snd data
        verbose "{irc-send} #@name << #{data}", 3
        @socket.write("#{data}\r\n")
        @out += "#{data}\r\n".length
      end

      # Run on the socket.
      def run
        loop do
          #recv @socket.readpartial(4096)
          recv @socket.readline("\r\n")
        end
      rescue EOFError
        @socket.close
        info "Connection to IRC network '#@name' lost!"
        emit :irc, :disconnected, self
      end

      # Receive data from the socket, and push it out for processing.
      #
      # @param [String] data
      def recv data

        # Increase in.
        @in += data.length
        # Strip CRLF and send for processing.
        line = data.chomp "\r\n"
        verbose "{irc-recv} #@name >> #{line}", 3
        emit :irc, :receive, self, line
      
        ###
        # Split the data.
        #recv = []
        #until data !~ /\r\n/
        #  line, data = data.split(/(?<=\r\n)/, 2)
        #  recv.push line.chomp "\r\n"
        #end
        #
        # Check if there's a remainder in the recvQ.
        #if @recv_rem != ''
        #  recv[0] = "#@recv_rem#{recv[0]}"
        #  @recv_rem = ''
        #end
        #@recv_rem = data if data != ''
        #
        ## Lastly, sent the data out
        #recv.each do |dline|
        #  verbose "{irc-recv} #@name >> #{dline}", 3
        #  emit :irc, :receive, self, dline # send it out to :receive
        #end
        ###
        
      end

      def to_s;    @name; end
      def inspect; "#<Syndi::IRC::Client: name='#@name'>"; end
      alias_method :s, :to_s

      # For Syndi::Talk communication.
      def to_talk
        hash = Hash.new
        instance_variables.each do |var|
          hash[var[2..-1]] = instance_variable_get var
        end
        hash
      end

      # To deserialize a Syndi::Talk capsule.
      def self.json_create o
        Syndi::IRC(o['data']['name'].lc)
      end

      #######
      private
      #######

      # Check the presence of all attributes.
      def attribute_check
        raise(ConfigError, 'Missing server address')  unless @address
        raise(ConfigError, 'Missing server port')     unless @port
        raise(ConfigError, 'Missing nickname to use') unless @nick
        raise(ConfigError, 'Missing username to use') unless @user
        raise(ConfigError, 'Missing realname to use') unless @real
      end

      # Check if we are connected.
      #
      # @return [true, false]
      def connected?
        return false unless @socket
        return false if @socket.closed?
        return false unless @connected
        true
      end

    end # class Client

  end # module IRC
end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
