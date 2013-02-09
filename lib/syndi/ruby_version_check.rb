if RUBY_VERSION < '2.0.0'
  desc = defined?(RUBY_DESCRIPTION) ? RUBY_DESCRIPTION : "ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE})"

  abort <<-message
    
    Syndi requires Ruby 2.0.0+.

    You're running
      #{desc}

    Please upgrade Ruby to proceed. For information on this, see the Syndi Handbook:
    http://syndibot.com/handbook/

  message
end
