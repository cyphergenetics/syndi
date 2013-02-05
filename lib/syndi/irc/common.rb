# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Syndi

  module IRC

    # A class which manages such common IRC functions as syndijoining channels,
    # and identifying to services the traditional PRIVMSG way.
    class Common

      # Construct a new common function handler.
      #
      # @param [Syndi::IRC::Library] lib The IRC library instance.
      def initialize lib
        @lib = lib
        $m.events.on   :die,       &method(:do_die)
        @lib.events.on :connected, &method(:do_syndijoin)
      end

      # Automatically identify with services the traditional way, which is
      # to say by a /msg.
      #
      # @param [Syndi::IRC::Server] irc The IRC connection.
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
      # @param [Syndi::IRC::Server] irc The IRC connection.
      def do_syndijoin irc
        if $m.conf['irc'][irc.s]['syndijoin']
          
          $m.conf['irc'][irc.s]['syndijoin'].each do |chan|
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

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
