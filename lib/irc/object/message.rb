# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Namespace: IRC
module IRC
  
  # Namespace: Object
  module Object
    
    # IRC::Object::Message
    #
    # A class which represents an IRC message, its associated properties, and
    # offers methods for working with the message.
    #
    # @since 4.0.0
    # @author noxgirl
    #
    # @!attribute [r] irc
    #   @return [IRC::Server] The server on which the message was received.
    #
    # @!attribute [r] sender
    #   @return [IRC::Object::User] The user from whom the message was received.
    #
    # @!attribute [r] body
    #   @return [Array<String>] The body of the message, divided into elements by its spaces.
    #
    # @!attribute [r] nature
    #   @return [Symbol] The nature of the message, `:notice` or `:msg`.
    #
    # @!attribute [r] channel
    #   @return [nil] If this message was received privately and not through a channel, this is nil.
    #   @return [IRC::Object::Channel] If it was received through a channel, the channel in question.
    #   @see #in_channel?
    class Message

      attr_reader :irc, :sender, :body, :nature, :channel

      # Process a new message.
      #
      # @param [IRC::Server] irc The server on which the message was received.
      # @param [IRC::Object::User] sender The user from whom the message was received.
      # @param [String] body The body of the message.
      # @param [Symbol] The nature of the message: either a `:notice` or a `:msg`. Default is `:notice`.
      # @param [IRC::Object::Channel] If it was received through a channel, the channel.
      def initialize(irc, sender, body, nature=:notice, channel=nil)

        @irc     = irc
        @sender  = sender
        @body    = body
        @nature  = nature
        @channel = channel

      end

      # Reply to this message.
      #
      # @param [String] msg The message with which to reply.
      # @param [Boolean] in_channel `true` if the response should be in-channel
      #   (assuming it was received in a channel), `false` if it should be private
      #   regardless of where it was received.
      #
      # @note Essentially reply() exists to simplify the API. 
      #   Rather than necessitating that commands use endless, illegible conditional
      #   nests to determine what to do, reply() is available so the API will just
      #   use some common sense to do it for them.
      #
      # @todo Unfinished.
      def reply(msg, in_channel)
        
        case @channel.nil, in_channel, @nature
        
        # Respond in-channel if this was sent to a channel *and* in_channel
        # is specified as true.
        when false, :public, :msg
          irc.msg(@channel, msg)

        # Likewise for channel notices. 
        when false, :public, :notice

        end

      end

      # Checks whether the message was received through a channel.
      #
      # @return [Boolean]
      def in_channel?; @channel.nil?; end

    end # class Message

  end # module Object

end # module IRC
