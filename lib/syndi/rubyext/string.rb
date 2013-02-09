# This changes the String class in Ruby's standard library to make life easier
# by aliasing String#uc to String#upcase and String#dc to String#downcase
class String
  alias_method :uc, :upcase
  alias_method :dc, :downcase
  alias_method :uc!, :upcase!
  alias_method :dc!, :downcase!

  # Somewhat imperfect camelization (from snake-case strings).
  def camelize
    if self !~ /_/
      capitalize
    else
      words = split /_/
      words.map! { |word| word.capitalize }
      words.join
    end
  end

end

# vim: set ts=4 sts=2 sw=2 et:
