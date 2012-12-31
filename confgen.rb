# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require "highline/import"

config = {}

def gen_q(depth, question, default_string="")
  string = ("|  " * depth)
  string << " `- " unless depth.zero?
  string << question << "\n"
  string << gen_p(depth) << " " << default_string << "  "
  string.chomp(" ")
end

def gen_p(depth)
  string = (" |  "*depth)
  string << ((depth.zero?) ? "|-" : " |-")
  string.strip
end

def add_server
  depth  = 0
  server = {}
  # We need the following information
  # - Server Name    [String]
  # - Address        [String]
  # - Port           [Integer]
  # - SSL?           [Boolean]
  # - NickNames      [Array<String>]
  # - Username       [String]
  # - Realname       [String]
  # - SASL:          [Array<Integer,String,String>]
  #   - timeout      [Integer]
  #   - username     [String]
  #   - password     [String]
  # - Identification [Array<String>]
  #   - Service      [String]
  #   - Command      [String]
  #   - password     [String]
  # - Autojoin       [Array<String>]
  #   - channel name [String]
  #   - key          [String]
  name = ask gen_q(depth, "What is the name of the network you are adding?")
  depth += 1
  server["address"] = ask(gen_q(depth, "What is the address of #{name}?"))
  server["port"]    = ask(gen_q(depth, "What is the port of #{name}?", "[<%= color('6667', BOLD) %>]")) do |q|
    q.default  = nil
    q.validate = /^\d*$/
  end || 6667
  server["useSSL"]  = ask(gen_q(depth, "Does this server use SSL?", "[<%= color('y', RED) %>/<%= color('N', BOLD, GREEN) %>]")) do |q|
    q.case = :down
    q.limit = 1
    q.responses[:not_valid] = proc { say("#{gen_p depth} Defaulting to <%= color('No', BOLD, RED) %>") }
    q.answer_type = proc {|x| if x == 'y' then true else false end }
  end
  nicknames = [ask(gen_q(depth, "What nicknames would you like to use? List in descending priority.")) {|q| q.default = nil }]
  if nicknames.first.empty?
    say(gen_p(depth) << "Defaulting to 'Auto'")
    nicknames = ["Auto"]
  else
    until (nick = ask(gen_p(depth) << "  ")).empty?
        nicknames << nick
    end
  end
  server["nickname"] = nicknames
  server["username"] = ask(gen_q(depth, "What username would you like to use?", "[<%= color('Auto', BOLD) %>]"))
  server["username"] = "Auto" if server["username"].empty?
  server["realName"] = ask(gen_q(depth, "What realname would you like to use?", "[<%= color('Auto IRC Bot', BOLD) %>]"))
  server["realName"] = "Auto IRC Bot" if server["realName"].empty?
  do_auth = ask(gen_q(depth, "Will you be authenticating with a login system? (SASL/NickServ)", "[<%= color('Y', BOLD, GREEN) %>/<%= color('n', RED) %>]")) do |q|
    q.case        = :down
    q.limit       = 1
    q.answer_type = proc {|x| if x == 'n' then false else true end }
  end

  if do_auth
    depth += 1
    type = ask("|   |   `- What system will you be using?\n|   |   |- [SASL/<%= color('NickServ', BOLD) %>]  ") do |q|
      q.case     = :down
      q.responses[:not_valid] = proc {
        say("Please enter either [SASL/<%= color('NickServ', BOLD) %>] (NickServ is the default)")
      }
      q.answer_type = proc {|x| if x == "sasl" then :SASL else :NickServ end }
    end
    depth += 1
    if type == :SASL
      server["SASL"] = {}
      server["SASL"]["timeout"] = ask("|   |   `- How long before a timeout occurs?\n|   |   |- [<%= color('15', BOLD) %>]  ") {|q| q.validate = /^\d*$/ } || 15
      server["SASL"]["username"] = ask("|   |   `- What username will you submit to authenticate with?\n|   |   |-  ")
      server["SASL"]["password"] = ask("|   |   `- What password will you submit to authenticate with?\n|   |   |-  ") {|q| q.echo = "*" }
    else
      server["nickIdentify"] = {}
      server["nickIdentify"]["service"] = ask("|   |   `- What is the name of the service you will be authenticating with?\n|   |   |- [<%= color('NickServ', BOLD) %>] ")||"NickServ"
      server["nickIdentify"]["command"] = ask("|   |   `- What is the command to authenticate with said service?\n|   |   |- [<%= color('identify', BOLD) %>]  ") ||"identify"
      server["nickIdentify"]["password"] = ask("|   |   `- What is the password you will use to authenticate?\n|   |   |- ") {|q| q.echo = "*" }
    end
    depth -= 2
  end

  channel = ask(gen_q(depth, "What channels would you like to join automatically? (Place any key needed after the name, separated by a space)")) do |q|
    q.validate = /^[^\w]/ # Check to make sure it at least isn't a plain word. Just in case we have a & or ! type channel prefix.
    q.default  = nil
  end

  if channel.nil?
    channels = []
  else
    channels = [{"name" => channel.split.first, "key" => channel.split(/\s/, 2).last}]
    until (chan = ask(gen_p(depth) << "  ")).empty?
      channels << {"name" => chan.split.first, "key" => chan.split(/\s/, 2).last}
    end
  end

  {name => server}
end


CONFGEN_VERSION = 0.1

#This really isn't needed. But I like `false` more than `nil`
options = Hash.new(false)
options[:irc] = true
options[:yaml] = true
options[:output] = $stdout

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
end.parse(ARGV)

at_exit do
  if options[:yaml]
    require "yaml"
    options[:output].puts YAML.dump(config)
  else
    require "json"
    options[:output].puts JSON.dump(config)
  end
end

if options[:irc]
  prc = proc do
    config.merge! add_server
    ask("Would you like to add another server?\n|- [y/<%= color('N', BOLD, RED) %>]  ") {|q| q.answer_type = proc {|x| if x =~ /n/i then false else true end } }
  end
  x = true
  x = prc.call while x
end

if options[:jabber]
  # Shit if I know
end

# vim: set ts=4 sts=2 sw=2 et:
