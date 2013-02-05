# This code exists in the public domain.

class DiffieHellman
  
  attr_reader :p, :g, :q, :x, :e

  # p is the prime, g the generator and q order of the subgroup
  def initialize p, g, q
    @p = p
    @g = g
    @q = q
  end

  # generate the [secret] random value and the public key
  def generate tries=16
    tries.times do
      @x = rand(@q)
      @e = self.g.mod_exp(@x, self.p)
      return @e if self.valid?
    end
    raise ArgumentError, "can't generate valid e"
  end

  # validate a public key
  def valid?(_e = self.e)
    _e and _e.between?(2, self.p-2) and _e.bits_set > 1
  end

  # compute the shared secret, given the public key
  def secret f
    f.mod_exp(self.x, self.p)
  end

end

# vim: set ts=4 sts=2 sw=2 et:
