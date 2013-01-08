# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'auto/irc/std/numerics'

module Auto

  module IRC

    class Protocol

      # An extension of {Auto::IRC::Protocol}, which parses numerics.
      module Numerics
        include Auto::IRC::Std::Numerics

        # RPL_WELCOME
        define_method("on_#{RPL_WELCOME}") do |irc, raw, params|
          $m.info "Successfully connected to #{irc} IRC network!" # log
        end

        # RPL_MYINFO
        define_method("on_#{RPL_MYINFO}") do |irc, raw, params|
          irc.supp.server_name = params[3]
        end

        # RPL_ISUPPORT
        define_method("on_#{RPL_ISUPPORT}") do |irc, raw, params|
          irc.supp.isupport(irc, params[3..-5].join(' ')) # process the isupport data
          irc.supp.connected = true
          $m.irc.events.call :connected, irc # emit the :connected event
        end

        # RPL_SASLSUCCESS
        define_method("on_#{RPL_SASLSUCCESS}") do |irc, raw, params|
          $m.info "SASL authentication on #{irc} succeeded!"
          irc.cap_end
        end

        # ERR_SASLFAIL
        define_method("on_#{ERR_SASLFAIL}") do |irc, raw, params|
          if irc.supp.sasl_method == :dh_blowfish
            irc.authenticate # try again with the PLAIN mechanism
          else
            # ope, failed
            $m.error "SASL authentication on #{irc} failed: received ERR_SASLFAIL from server."
            irc.cap_end
          end
        end

      end # class Numerics

    end # class Protocol

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
