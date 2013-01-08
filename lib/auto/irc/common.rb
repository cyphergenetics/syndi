# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto

  module IRC

    # A class which manages such common IRC functions as autojoining channels,
    # and identifying to services the traditional PRIVMSG way.
    class Common

      # Construct a new common function handler.
      #
      # @param [Auto::IRC::Library] lib The IRC library instance.
      def initialize lib
        lib.events.on :connected, &method(:do_autojoin)
      end

      # Automatically join IRC channels upon connection.
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      def do_autojoin irc
        if $m.conf['irc'][irc.s]['autojoin']
          
          $m.conf['irc'][irc.s]['autojoin'].each do |chan|
            irc.join(chan['name'], chan['key']||nil)
          end

        end
      end

    end # class Common

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
