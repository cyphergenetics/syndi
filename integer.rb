# This code exists in the public domain.

# Extends Integer with some needed methods for Diffie-Hellman key exchange.
class Integer
  
  # Compute self ^ e mod m
  def mod_exp e, m
    result = 1
    b = self
    while e > 0
      result = (result * b) % m if e[0] == 1
      e = e >> 1
      b = (b * b) % m
    end
    return result
  end

  # A roundabout, slow but fun way of counting bits.
  def bits_set
    ("%b" % self).count('1')
  end

end

# vim: set ts=4 sts=2 sw=2 et:
