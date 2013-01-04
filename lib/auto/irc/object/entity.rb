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
      #
      # @!attribute [r] name
      #   @return [String] The name of the entity.
      class Entity

        attr_reader :irc, :name

        # New instance.
        #
        # @param [Auto::IRC::Server] irc The server.
        # @param [Symbol] type Either +:channel+ or +:user+.
        # @param [String] name The name of this entity (nickname or channel name).
        def initialize(irc, type, name)
          @irc         = irc
          @entity_type = type
          @name        = name
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
          len     = ":#{@irc.nick}!#{@irc.user}@#{@irc.mask} #{command} #@name :".length
          raw     = ":#{@irc.nick}!#{@irc.user}@#{@irc.mask} #{command} #@name :#{message}\r\n"

          if raw.length > 512
            
            msgs     = []
            nmessage = message 
            until raw.length <= 512
              msgs << nmessage.slice!(0, 512-len)
              raw = ":#{@irc.nick}!#{@irc.user}@#{@irc.mask} #{command} #@name :#{nmessage}\r\n"
            end
            
            msgs.each { |m| @irc.snd "#{command} #@name :#{m}" }
          
          else
            @irc.snd "#{command} #@name :#{message}"
          end

          $m.events.call 'irc:onMsg', self, message

        end # def msg

        def to_s; @name; end

      end # class Entity

    end # module Object

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
