# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'base64'

module Auto

  module IRC
  
    module SASL

      module Mech

        # Module which implements the SASL PLAIN mechanism.
        module Plain

          # Create an SASL-encrypted hash.
          #
          # @param [String] username The username.
          # @param [String] password The password associatd with the username.
          # @param [String] provision The key provided by the server.
          def self.encrypt username, password, provision
            # Easy as this:
            Base64.encode64([username, username, password].join("\0")).gsub(/\n/, '')
          end

        end # module Plain

      end # module Mech

    end # module SASL

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
