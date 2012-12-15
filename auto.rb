#!/usr/bin/env ruby
# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Program variables.
VERSION = '4.0.0-dev'

# Require necessary libraries.
require 'optparse'

# Parse options.
mopts = { 'debug' => false, 'foreground' => false }
OptionParser.new do |opts|

  # Set banner.
  opts.banner = "Usage: ruby #$0 [options]"

  # Set separator.
  opts.separator ''
  opts.separator "Options:"

  # Debug flag.
  opts.on('-d', '--debug', "Execute in debug mode.") { |v| mopts['debug'] = true }

  # Foreground flag.
  opts.on('-f', '--foreground', "Do not fork into the background.") { |v| mopts['foreground'] = true }

  # Version flag.
  opts.on('-v', '--version', "Print version and exit.") do |v|
    puts <<VERSION
Auto #{VERSION}
https://github.com/noxgirl/Auto
VERSION
    exit 0
  end

end.parse!

# Begin start up.
puts "* Auto #{VERSION} starting..."

# Enter main directory.
Dir.chdir(File.dirname(__FILE__))

# Require our libraries.
require_relative 'lib/ruby_core_ext.rb'
require_relative 'lib/auto.rb'
require_relative 'lib/core/logging.rb'
require_relative 'lib/parser/config.rb'
#require_relative 'lib/parser/irc.rb'
#require_relative 'lib/irc/std.rb'
#require_relative 'lib/irc/state/client.rb'
#require_relative 'lib/irc/state/channel.rb'
#require_relative 'lib/irc/state/user.rb'
#require_relative 'lib/api/plugin.rb'
#require_relative 'lib/api/command.rb'
require_relative 'lib/api/timers.rb'
require_relative 'lib/api/events.rb'

# Create an instance of Auto.
$m = Auto.new(mopts)
status = $m.init

# Check our status.
time = nil
if status
  time = Time.now
  puts "* Auto started @ #{time}"
  $m.log.info("Auto started @ #{time}")
else
  puts "Start up failed! Read above for errors."
  exit 0
end
STARTTIME = time

# We survived? We survived! Fork into the background if not in debug or foreground.
unless mopts['debug'] or mopts['foreground']
  puts "Forking into the background..."
  # Direct all incoming data on STDIN and outgoing data on STDOUT/STDERR to /dev/null.
  $stdin = File.open('/dev/null')
  $stdout = File.open('/dev/null', 'w')
  $stderr = File.open('/dev/null', 'w')
  # Fork and retrieve the PID.
  pid = fork

  # Save it to auto.pid.
  unless pid.nil?
    File.open('auto.pid') { |io| io.puts pid }
    exit 0
  end
end

# The following should capture all exceptions that are not caught:
begin
  # Start the bot.
  $m.start
rescue => e
  $m.error("FATAL EXCEPTION: #{e}", true, e.backtrace)
end

# vim: set ts=4 sts=2 sw=2 et:
