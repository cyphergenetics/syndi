# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

module Auto

  module IRC

    # A class which manages such common IRC functions as autojoining channels,
    # and identifying to services the traditional PRIVMSG way.
    class Common

      # Construct a new common function handler.
      #
      # @param [Auto::IRC::Library] lib The IRC library instance.
      def initialize lib
        @lib = lib
        $m.events.on   :die,       &method(:do_die)
        @lib.events.on :connected, &method(:do_autojoin)
      end

      # Automatically identify with services the traditional way, which is
      # to say by a /msg.
      #
      # @param [Auto::IRC::Server] irc The IRC connection.
      def do_identify irc
        if $m.conf['irc'][irc.s]['nickIdentify']
          
          # Assume the service is NickServ if not specified
          service = $m.conf['irc'][irc.s]['nickIdentify']['service'] || 'NickServ'
          # and assume the command is IDENTIFY if not specified
          command = $m.conf['irc'][irc.s]['nickIdentify']['command'] || 'IDENTIFY'

          # we can't actually /msg anyone yet.....
        end
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

      # Disconnect from servers on termination.
      #
      # @param [String] reason Reason for termination.
      def do_die reason
        @lib.connections.each { |net, irc| irc.disconnect reason }
      end

    end # class Common

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
