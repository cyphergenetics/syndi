# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'base64'
require 'openssl'
require 'auto/rubyext/integer'
require 'auto/irc/sasl/diffie_hellman'

module Auto

  module IRC
  
    module SASL

      module Mech

        # Module which implements the SASL DH-BLOWFISH mechanism.
        # @author noxgirl
        module DHBlowfish

          # Create an SASL-encrypted hash.
          #
          # @param [String] username The username.
          # @param [String] password The password associated with the username.
          # @param [String] provision The key provided by the server.
          def self.encrypt username, password, provision
            # This is a fairly complex process. Duplicate +username+ and
            # +password+ for safety.
            user = username.dup
            pass = password.dup

            # Decode the key from base64.
            key = Base64.decode64(provision).force_encoding('ASCII-8BIT')

            # Unpack it.
            p, g, y = unpack_key key

            dh     = DiffieHellman.new(p, g, 23)
            pkey   = dh.generate
            secret = OpenSSL::BN.new(dh.secret(y).to_s).to_s(2)
            pub    = OpenSSL::BN.new(pkey.to_s).to_s(2)

            pass.concat "\0"
            pass.concat('.' * (8 - (password.size % 8)))

            cipher         = OpenSSL::Cipher::Cipher.new 'BF-ECB'
            cipher.key_len = 32
            cipher.encrypt
            cipher.key     = secret

            enc    = cipher.update(pass).to_s
            answer = [pub.bytesize, pub, user, enc].pack('na*Z*a*')

            Base64.strict_encode64(answer) # finally, return the hash
          end

          # @return [Array(Numeric, Numeric, Numeric)] +p+, +g+, and +y+ for
          #   Diffie-Hellman key exchange
          def self.unpack_key key
            key = key.dup
            pgy = []

            3.times do
              size = key.unpack('n').first
              key.slice! 0, 2
              pgy << key.unpack("a#{size}").first
              key.slice!(0, size)
            end
            
            pgy.map { |int| OpenSSL::BN.new(int, 2).to_i }
          end

        end # module DHBlowfish

      end # module Mech

    end # module SASL

  end # module IRC

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
