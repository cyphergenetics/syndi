# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto

  module IRC
  
    module Object

      # A superclass which represents an IRC 'entity'; i.e., a channel or user.
      # It acts as a base for {Auto::IRC::Object::User} and {Auto::IRC::Object::Channel}.
      #
      # @api IRC
      # @since 4.0.0
      # @author noxgirl
      #
      # @!attribute [r] irc
      #   @return [Auto::IRC::Server] The IRC server on which this entity exists.
      class Entity

        attr_reader :irc

        # New instance.
        #
        # @param [Auto::IRC::Server] irc The server.
        # @param [Symbol] type Either +:channel+ or +:user+.
        def initialize(irc, type)
          @irc         = irc
          @entity_type = type
        end

        # @return [true, false] Whether we're a channel.
        def channel?
          @entity_type == :channel ? true : false
        end
        
        # @return [true, false] Whether we're a user.
        def user?
          @entity_type == :user ? true : false
        end

        # Send a message to this entity. This will additionally divide messages
        # which are too long into multiple messages.
        #
        # This will call irc:onMsg with +self+ and +message+.
        #
        # @param [String] message The message.
        # @param [true, false] notice Whether this should be a /notice as opposed
        #   to a /msg.
        def msg(message, notice=false)
          
          command = (notice == false ? 'PRIVMSG' : 'NOTICE')
          len     = ":#{@irc.nick}!#{@irc.user}@#{@irc.mask} #{command} :".length
          raw     = ":#{@irc.nick}!#{@irc.user}@#{@irc.mask} #{command} :#{message}\r\n"

          if raw.length > 512
            
            msgs     = []
            nmessage = message 
            while raw.length > 512
              msgs << nmessage.slice!(0, 512-len)
              raw = ":#{@irc.nick}!#{@irc.user}@#{@irc.mask} #{command} :#{nmessage}\r\n"
            end
            
            msgs.each { |m| @irc.snd "#{command} :#{m}" }
          
          else
            @irc.snd "#{command} :#{message}"
          end

          $m.events.call 'irc:onMsg', self, message

        end # def msg

      end # class Entity

    end # module Object

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
