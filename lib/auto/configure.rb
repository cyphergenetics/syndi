# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'colored'
require 'highline'
require 'yaml'

$S = '>>>'.blue


# Check To make sure that we have a decent ruby version. There is no reason to support a
# version that has reached EOL.
if RUBY_VERSION < "1.9"
  puts <<-EOM
The version of ruby that you are using is out dated. Please upgrade to a version of at least
1.9.1 to run auto. The ruby source code is located here http://ruby-lang.org/en/downloads
  EOM
end

# namespace Auto
module Auto

  # A library for configuration generation. It depends upon the highline gem.
  #
  # @version 1.02
  # @author swarley
  # @author noxgirl
  #
  # @!attribute hl
  #   @return [HighLine] HighLine instance.
  #
  # @!attribute conf
  #   @return [Hash{}] The configuration hash.
  class Configure

    autoload :Shell, 'auto/configure/shell'
    # Load the shell.
    def shell
      Auto::Configure::Shell.new
    end

    VERSION = '1.02'.freeze
    AUTODIR = File.join(Dir.home, '.config', 'autobot')

    attr_accessor :hl, :conf

    # Produce a new instance of Auto::Configure.
    def initialize
      
      # Produce a new instance of HighLine.
      @hl   = HighLine.new
      # Prepare for configuration.
      @conf = Hash.new

    end

    # Initiate configuration.
    def generate
      
      greeting = <<-EOM
Greetings! ^.^

I am going to assist you in configuring your installation of Auto. :) I suggest
that, if you're not already reading it, you consult the installation guide:
https://github.com/Auto/Auto/wiki/Install-Guide

When specifying lists, separate elements by commas.

Remember, if you need additional help, you're free to use the mailing list at
https://groups.google.com/group/autobot-talk, or to join the official IRC
channel at #auto on irc.freenode.net. :)

Let us begin!
      EOM
      puts greeting.yellow.bold

      conf_libraries
      conf_database

      dump

    end

    # Configure libraries.
    def conf_libraries
      puts ">>> Currently, the only available library is the IRC library. I will load this automatically.".cyan.bold
      @conf['libraries'] = ['irc']

      conf_irclib
    end

    # Configure the IRC library.
    def conf_irclib

      # Create the configuration hash.
      @conf['irc'] = {}

      # Add the first server.
      conf_irc_add_server

      # Add subsequent servers.
      another = @hl.agree("#$S Would you like to add another IRC server?  ") { |q| q.default = 'n' }
      while another
        conf_irc_add_server
        another = @hl.agree("#$S Would you like to add another IRC server?  ") { |q| q.default = 'n' }
      end

    end

    # Add an IRC server.
    def conf_irc_add_server

      # We need a name.
      name = @hl.ask("#$S What is the name of this IRC server?  ")
      while @conf['irc'].include? name
        puts "You've already specified that server. Use a different name.".red.bold
        name = @hl.ask("#$S What is the name of this IRC server?")
      end

      # We need an address.
      address = @hl.ask("#$S What is the address of <%= color('#{name}', :blue, :bold) %>?  ")

      # And a port.
      port = @hl.ask("#$S What is the port of <%= color('#{name}', :blue, :bold) %>?  ", Integer) { |q| q.default = 6667 }

      # Does it use SSL?
      ssl = @hl.agree("#$S Does <%= color('#{address}:#{port}', :blue, :bold) %> use SSL?  ") { |q| q.default = 'n' }
      
      # What nickname(s) should we use?
      nicks = @hl.ask("#$S What nicknames should I use on <%= color('#{name}', :blue, :bold) %> (list in descending priority)?  ",
                      ->(str) { str.split(/,\s*/) }) { |q| q.default  = 'auto' }
      nicksvalid = true
      nicks.each { |n| nicksvalid = false unless n =~ /^[\w\d\[\]\{\}\^\-\_\`]+$/ }
      until nicksvalid
        puts "You entered an invalid nickname. Try again.".red.bold
        nicks = @hl.ask("#$S What nicknames should I use on <%= color('#{name}', :blue, :bold) %> (list in descending priority)?  ",
                        ->(str) { str.split(/,\s*/) }) { |q| q.default  = 'auto' }
        nicksvalid = true
        nicks.each { |n| nicksvalid = false unless n =~ /^[\w\d\[\]\{\}\^\-\_\`]+$/ }
      end

      # What username?
      user = @hl.ask("#$S What username should I use on <%= color('#{name}', :blue, :bold) %>?  ") { |q| q.default = 'auto' }

      # What GECOS?
      gecos = @hl.ask("#$S What real name or GECOS should I use on <%= color('#{name}', :blue, :bold) %>?  ") { |q| q.default = 'Auto (http://auto.autoproj.org)' }

      # Save the data.
      @conf['irc'][name] = {
        'address'  => address,
        'port'     => port,
        'useSSL'   => ssl,
        'nickname' => nicks,
        'username' => user,
        'realName' => gecos
      }

      # Should we use SASL?
      sasl = @hl.agree("#$S Should I use SASL to authenticate with services on <%= color('#{name}', :blue, :bold) %>?  ") { |q| q.default = 'n' }

      if sasl
        
        sasl_user = @hl.ask("#$S What username (i.e. accountname) should I use in SASL authentication?  ")
        sasl_pass = @hl.ask("#$S What is the password for <%= color('#{sasl_user}', :blue, :bold) %>?  ") { |q| q.echo = false }
        sasl_to   = @hl.ask("#$S After how many seconds should SASL authentication time out?  ", Integer) { |q| q.default = 15 }

        @conf['irc'][name]['SASL'] = {
          'username' => sasl_user,
          'password' => sasl_pass,
          'timeout'  => sasl_to,
        }

      else
        # Perhaps NickServ or some other service?
        auth = @hl.agree("#$S OK. Should I identify with a service (e.g. NickServ)?  ") { |q| q.default = 'n' }

        if auth

          service  = @hl.ask("#$S What service should I message?  ") { |q| q.default = 'NickServ' }
          command  = @hl.ask("#$S What command should I use to identify?  ") { |q| q.default = 'IDENTIFY' }
          password = @hl.ask("#$S What password should I use?  ") { |q| q.echo = false }

          @conf['irc'][name]['nickIdentify'] = {
            'service'  => service,
            'command'  => command,
            'password' => password
          }

        end

      end

      # Setup autojoin.
      conf_irc_autojoin name
      
    end

    # Configure autojoin.
    #
    # @param [String] name Name of IRC server.
    def conf_irc_autojoin(name)
      another = @hl.agree("#$S Should I automatically join a channel on <%= color('#{name}', :blue, :bold) %>?  ") { |q| q.default = 'y' }
      @conf['irc'][name]['autojoin'] = []

      while another
        @conf['irc'][name]['autojoin'] << conf_irc_add_channel
        another = @hl.agree("#$S Should I automatically join another channel?  ") { |q| q.default = 'n' }
      end
    end

    # Add an IRC channel.
    #
    # @param [String] server The name of the IRC server.
    def conf_irc_add_channel
      
      # What's it called?
      name = @hl.ask("#$S What is the name of the channel?  ") { |q| q.default = '#auto' }

      # Does it use a key?
      usekey = @hl.agree("#$S Does <%= color('#{name}', :blue, :bold) %> use a key (+k)?  ") { |q| q.default = 'n' }
      key    = nil

      if usekey
        key = @hl.ask("#$S What is the key?  ")
      end

      {'name' => name, 'key' => key}
    end

    # Configure the database.
    def conf_database
    
      msg = <<-eom
>> Auto supports three database management systems: SQLite 3, MySQL, and Postgres.
>> If you use SQLite 3, you need the 'sqlite3' gem.
>> If you use MySQL, you need the 'mysqlplus' gem.
>> If you use Postgres, you need the 'pg' gem.
>> See https://github.com/Auto/Auto/wiki/Install-Guide for more information.
      eom
      puts msg.cyan

      type = @hl.ask("#$S What database management system should I use? (sqlite, mysql, or postgres)  ") do |q|
        q.default  = 'sqlite'
        q.validate = /^(sqlite|mysql|postgres)$/
      end
      @conf['database']['type'] = type

      if type == 'sqlite'
      
        file = @hl.ask("#$S What should be the filename of the database? (relative to <%= color('#{AUTODIR}', :blue, :bold) %>)  ") do |q|
          q.default = File.join AUTODIR, 'auto.db'
        end

        unless Dir.exists File.dirname(file)
          puts "Warning: Directory #{File.dirname(file)} does not exist.".red.bold
        end

        @conf['database']['name'] = file

      else # mysql and pg

        address = @hl.ask("#$S What is the host address of the <%= color('#{type}', :blue, :bold) %> server?  ") { |q| q.default = 'localhost' }
        name = @hl.ask("#$S What is the database name on the <%= color('#{type}', :blue, :bold) %> server?  ") { |q| q.default = 'auto' }
        username = @hl.ask("#$S What username should I use to connect to <%= color('#{type}', :blue, :bold) %> server?  ") { |q| q.default = 'auto' }
        password = @hl.ask("#$S What is the password for <%= color('#{username}', :blue, :bold) %>?  ") { |q| q.echo = false }

        @conf['database'].merge!({
          'address'  => address,
          'name'     => name,
          'username' => username,
          'password' => password
        })

      end

    end

    # Dump configuration.
    def dump

      # A sanity check.
      if @conf.empty?
        puts "Configuration is inexplicably empty: aborting.".red.bold
        exit 1
      end

      # Produce file.
      data = <<-EOD
# Configuration file generated by auto-conf
# version #{Auto::Configure::VERSION}
# at #{Time.now}

#{YAML.dump(@conf)}
      EOD
      
      # Produce message.
      final = <<-EOM
OK! Your configuration file is ready! :D

I just need to know one last thing: where to write this fabulous configuration.

By default, I will write this to <YOUR_HOME_DIRECTORY>/.config/autobot/auto.yml,
which is perfect for you if you're using the 'autobot' gem, because this is the
standard file for which the gem will look when executed.

However, if you are running a standalone installation, you probably want to
write this to your conf/ directory as auto.yml (if you're running #$0 from the
main directory, "conf/auto.yml"), as the standalone Auto will look for that
when it is executed.

In any event, you are free to write this anywhere you please. Just remember
that if it is not a default path, you must specify it when running Auto:

$ auto --config=path/to/config/file.yml

Caution: The specified file will be overwritten if it already exists.
      EOM
      puts final.green.bold

      # Save our directories of interest into easily accessible variables.
      configdir = File.join(Dir.home, '.config')

      # Ensure that said directories exist regardless of any other conditions.
      unless Dir.exists? configdir
        puts "~ Creating missing directory #{configdir}".magenta
        Dir.mkdir configdir
      end
      unless Dir.exists? AUTODIR
        puts "~ Creating missing directory #{AUTODIR}".magenta
        Dir.mkdir AUTODIR
      end

      # Ask for a path.
      path = @hl.ask("#$S To where should the configuration be written?  ", String) do |q|
        
        # Default is ~/.config/autobot/auto.yml
        q.default  = File.join(autodir, 'auto.yml')

        # A proc to validate the path
        q.validate = proc do |path|
          return false unless path =~ /\.yml$/ # it should end in .yml
          return false unless Dir.exists? File.dirname(path) # the directory should exist
          # We should be able to write to the file:
          begin
            File.open(path, 'w') { |io| io.puts "# Configuration file generated by auto-conf" }
          rescue => e
            return false
          end
          true
        end

        # A proc to be called in the event of an invalid path
        q.responses[:not_valid] = proc do
          
          # Choose an emergency file in ~/.config/autobot/ to which to save.
          emerg_file = File.join(autodir, "auto.yml.#{Time.now.strftime('%s')}")
          puts "Invalid path! Attempting to write to #{emerg_file}.....".red
          File.open(path, 'w') do |io| 
            io.write data
          end

        end

      end # ask()

      File.open(path, 'w') { |io| io.write data } # Dump the data into the file.

      # We're done.
      puts "I have successfully written your configuration file to #{path}. Thank you for using Auto.".green.bold

    end

  end # class Configure

end # module Auto

# This will fix a certain undesirable output.
#
# HighLine::Question#append_default appends an ugly manifestation of the
# default answer.
#
# This destroys that provided by HighLine::Question and in lieu uses a prettier
# one.
class HighLine
  class Question
    def append_default
      str = ''
      if @default == 'y'
        str = "<%= color('Y', :green) %>/<%= color('n', :red) %>"
      elsif @default == 'n'
        str = "<%= color('y', :green) %>/<%= color('N', :red) %>"
      else
        str = "<%= color('#@default', :bold) %>"
      end

      if @question =~ /([\t ]+)\Z/
        @question << "[#{str}]#{$1}"
      elsif @question == ""
        @question << "[#{str}]  "
      elsif @question[-1, 1] == "\n"
        @question[-2, 0] =  "  [#{str}]"
      else
        @question << "  [#{str}]"
      end
    end
  end
end

# vim: set ts=4 sts=2 sw=2 et:
