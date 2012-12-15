# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Entering namespace: IRC
module IRC

  # Entering namespace: State
  module State

    ###
    # Class Client: Maintain our client data.
    ###
    class Client

      attr_reader :nick, :user
      attr_accessor :newnick

      # Create a new instance of IRC::State::Client.
      # (obj, str)
      def initialize(irc, nick)
        # Save the IRC object.
        @irc = irc

        # And our assumed nickname.
        @nick = nick
      end

      # Create binds to client state related hooks.
      # ()
      def start

        # Nick change.
        $m.events.on(self, 'Irc.OnBotNick') do |irc, newnick|
          if irc == @irc
            @nick = newnick
          end
        end
