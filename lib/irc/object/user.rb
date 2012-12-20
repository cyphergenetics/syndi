# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

#########################################
# IRC::Object::User
#
# A class which represents a user on IRC.
#########################################

# Namespace: IRC
module IRC

  # Namespace: Object
  module Object

    # Class: User
    class User

      attr_accessor :nick, :user, :host, :account

      # Create a new instance.
      def initialize(nickname, username=nil, hostname=nil, away=false)

        @nick    = nickname
        @user    = username
        @host    = hostname
        @away    = away
        @account = nil

      end

      # Process updates to information.
      def update(nickname=nil, username=nil, hostname=nil, away=false)
        
        unless nickname.nil?
          @nick = nickname
        end

        unless username.nil?
          @user = username
        end

        unless hostname.nil?
          @host = hostname
        end

        @away = away
      
      end

      # Process a login.
      def login(accountname)
        unless accountname.nil?
          @account = accountname
        end
      end

      # Process a logout.
      def logout
        @account = nil
      end

      # away= is special in that it must be a boolean.
      def away=(new)
        if new == true or new == false
          @away = new
        end
      end

      # Check if their username is known.
      def user_known?
        if @user == nil then false
        else true
        end
      end

      # Check if their hostname is known.
      def host_known?
        if @host == nil then false
        else true
        end
      end

      # Check if they are logged in.
      def logged_in?
        if @account == nil then false
        else true
        end
      end

    end # class User

  end # module Object

end # module IRC
