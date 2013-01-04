# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto

  # Namespace: IRC
  module IRC

    # Namespace: Object
    module Object

      # A class which represents an individual user on IRC, and which provides
      # useful data regarding said user, and methods using which to interact
      # with the user.
      #
      # @api IRC
      # @since 4.0.0
      # @author noxgirl
      #
      # @!attribute irc
      #   @return [Auto::IRC::Server] The server on which the user is located.
      #
      # @!attribute nick
      #   @return [String] The user's nickname.
      #
      # @!attribute user
      #   @return [String] If known, the user's username or ident.
      #   @return [nil] If unknown.
      #   @see #user_known?
      #
      # @!attribute host
      #   @return [String] If known, the user's hostname or mask.
      #   @return [nil] If unknown.
      #   @see #host_known?
      #
      # @!attribute account
      #   @return [String] If the user is logged in, their account name.
      #   @see #logged_in?
      #
      # @!attribute away
      #   @return [true] If the user is away.
      #   @return [false] If the user is present.
      class User < Entity

        attr_reader :nick, :user, :host, :account, :away

        # Process a new user.
        #
        # @param [Auto::IRC::Server] irc The server the user is on.
        # @param [String] nickname The user's nickname.
        # @param [String] username The user's username or ident.
        # @param [String] hostname The user's hostname or mask.
        # @param [true, false] away Whether the user is away: +true+ or +false+.
        #
        # @example
        #   user = Auto::IRC::Object::User.new(irc, 'missfoo', 'cowmilk', 'the.night.is.lovely', false)
        def initialize(irc, nickname, username=nil, hostname=nil, away=false)

          super(irc, :user) # Entity#initialize
          @nick    = nickname
          @user    = username
          @host    = hostname
          @away    = away
          @account = nil

        end

        # If the user logs into an account, this is used to specify the name of
        # the account with which ze has identified.
        #
        # @param [String] accountname The name of the account.
        #
        # @example
        #   user.login('root')
        def login(accountname)
          unless accountname.nil?
            @account = accountname
          end
        end

        # If the user logs out of hir account, this is used to update their
        # logged-in status.
        def logout
          @account = nil
        end

        # Update the user's known away status.
        #
        # @param [true, false] new The user's new away status, which should be +true+ or +false+.
        def away=(new)
          if new == true or new == false
            @away = new
          end
        end
      
        # Update the user's known hostname or mask.
        #
        # @param [String] new The user's new hostname.
        def host=(new); @host = new unless new.nil?; end

        # Update the user's known nickname.
        #
        # @param [String] new The user's new nickname.
        def nick=(new); @nick = new unless new.nil?; end
      
        # Update the user's known username or ident.
        #
        # @param [String] new The user's new username.
        def user=(new); @user = new unless new.nil?; end

        # This will check whether the user's username is known.
        #
        # @return [true] If known.
        # @return [false] If Unknown.
        def user_known?; @user.nil? ? false : true; end
      
        # This will check whether the user's hostname is known.
        #
        # @return [true] If known.
        # @return [false] If Unknown.
        def host_known?; @host.nil? ? false : true; end
      
        # This will check whether the user is logged in.
        #
        # @return [true] If known.
        # @return [false] If Unknown.
        def logged_in?; @account.nil? ? false : true; end

        def to_s; @nick; end
        def inspect; "#<Auto::IRC::Object::User: irc=#@irc nick=#@nick account=#@account>"; end

      end # class User

    end # module Object

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
