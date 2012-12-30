# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

require "optparse"
require "readline"

CONFGEN_VERSION = 0.1

#This really isn't needed. But I like `false` more than `nil`
options = Hash.new(false)
options[:irc] = true
options[:yaml] = true
options[:output] = $stdout

parser = 
OptionParser.new do |opt|
  opt.banner = "Usage: ./#$0 [-syj] output_file"

  opt.on("-s", "--shell", "Generate a configuration via a console.") do
    options[:shell] = true
  end

  opt.on("-y", "--yaml", "Generate a YAML configuration file. This is the default output.") do
    options[:yaml] = true
    options[:json] = false
  end

  opt.on("-j", "--json", "Generate a JSON configuration file, the default is YAML.") do
    options[:yaml] = false
    options[:json] = true
  end

  opt.on("--irc", "Create a configuration for IRC.") do
    options[:irc] = true
  end

  opt.on("--no-irc", "Do not create a configuration for IRC.") do
    options[:irc] = false
  end

  opt.on("--jabber", "Create a configuration for Jabber.") do
    options[:jabber] = true
  end

  opt.on("--no-jabber", "Do not create a configuration for Jabber. This is the default.") do
    options[:jabber] = false
  end

  opt.on("-v", "--version", "Display a version string and exit.") do
    puts "Auto 4 Configuration Generator\n\nRuby #{RUBY_VERSION} -- confgen #{CONFGEN_VERSION}"
    exit
  end

  opt.on("-h", "--help", "Display help text and exit") do
    puts opt
    exit
  end

  opt.on("-o FILE", "--output FILE", "The name of the configuration output. This defaults to STDOUT") do |string|
    options[:output] = File.open(string, "a+")
  end
end

parser.parse(ARGV)

if options[:shell]
  #shell mode parsing
end

# Otherwise, start asking questions

# Empty Hash, this will contain the items that will be output as YAML/JSON
output = {}

if options[:jabber]
  output["modules"] = ["jabber"]
else
  output["modules"] = ["irc"]
end

# First, ask about the plugins you're going to load

# Add the files from the module directory as auto completion options.
Dir.chdir("plugins/#{output["modules"].first}")
FILES = Dir["*"]
Dir.chdir("../../")

Readline.completion_proc = proc {|string| FILES.grep(/^#{Regexp.escape string}/) }
plugs = [Readline.readline("What plugins would you like to load? [Submit an empty line when you are done.]\n`- > ")]
until (plug = Readline.readline(" | > ").strip).empty?
  plugs << plug
end

output["plugins"] = plugs


def add_server()
  settings = {}
  name = Readline.readline("What is the name of the server you are adding?\n`- > ")
 
  settings["address"] = Readline.readline("  |- What is the address of the server? ").strip

  port = port_num()
  if port.nil?
    port = port_num until !port.nil?
  end
  settings["port"] = port
  
  ssl = use_ssl()
  if ssl.nil?
    ssl = use_ssl() until !ssl.nil?
  end
  settings["useSSL"] = ssl
  
  puts "  |- What nicknames would you like for the bot to use? List in descending priority"
  nick = Readline.readline("  |  `- > ")
  if nick.strip.empty?
    nicks = ["Auto"]
    puts "Defaulting to [Auto]"
  else
    nicks = [nick]
    nicks << nick until (nick = Readline.readline("  |    |- ")).strip.empty?
  end

  settings["nickname"] = nicks

  settings["username"] = Readline.readline("  |- What username do you wish to use? ").strip

  settings["realname"] = Readline.readline("  |- What realname do you wish to use? ").strip

  auth = authentication
  if auth
    settings.merge!(auth)
  end

  return [name, settings]
end

def port_num()
  port = Readline.readline("  |- What port will the connection be on? [6667] ") 
  if port.strip.empty?
    return 6667
  elsif port.to_i != 0
    return port.to_i
  else
    puts "Please try again with a numerical answer."
    return nil
  end
end

def use_ssl()
  s = Readline.readline("  |- Does this server use SSL? [y/N] ")
  if s.downcase =~ /^(?:y|n)/
    return (s.downcase =~ /^y/) ? true : false
  elsif s.strip.empty?
    return false
  else
    puts "Please try again with a Y (Yes) or N (No) answer."
    return nil
  end
end

def authentication()
  prc = lambda {
    r = Readline.readline("  |- Will you be authenticating? [Y/n] ").downcase
    if r =~ /^(?:y|n)/
      (r =~ /^y/) ? true : false
    elsif r.strip.empty?
      true
    else
      nil
    end
  }
  ans = prc.call
  ans = prc.call until !ans.nil?
  if ans
    prc = lambda {
      r = Readline.readline("  |  `- What form of authentication will you use? [SASL/\e[2mNickServ\e[0m] ").downcase
      if r =~ /^(?:sasl|nickserv)/
        (r =~ /^sasl/) ? :sasl : :nickserv
      elsif r.strip.empty?
        :nickserv
      else
        nil
      end
    }
    ans = prc.call
    ans = prc.call until !ans.nil?
    if ans == :sasl
      return {"SASL" => {"timeout" => 15, "username" => Readline.readline("  |  |  |- What username will you use to identify? "),
              "password" => Readline.readline("  |  |  |- What password will you use to identify? ")}}
    else
      return {"nickIdentify" => {"service" => "NickServ", "command" => "identify", "password" => Readline.readline("  |   |  `- What is the password you will be using? ")}}
    end
  end
end

at_exit do
  if options[:json]
    require "json"
    options[:output].puts JSON.dump(output)
  else
    require "yaml"
    options[:output].puts YAML.dump(output)
  end
end

begin
  if options[:irc]
    output["irc"] = {}
    server = add_server()
    output["irc"][server[0]] = server[1]
    until Readline.readline("Add another server? [Y/n] ").downcase =~ /^n/
      server = add_server
      output["irc"][server[0]] = server[1]
    end
  end
  if options[:jabber]
    # Shit if I know
  end
rescue Interrupt
  print "\n"
  exit
end

# vim: set ts=4 sts=2 sw=2 et:
