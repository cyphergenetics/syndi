# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'yaml'

module Auto

  class Configure
    
    # A class which allows for interaction with the current configuration,
    # in contrast to generation of an entirely new one.
    class Shell

      # A list of commands.
      COMMANDS = {
        'lib.add'                     => "Add a library to loading.",
        'lib.ls'                      => "Display a list of libraries currently loaded and available.",
        'lib.rm'                      => "Remove a library from loading."
      }

      # @param [HighLine] hl HighLine instance.
      def initialize(hl)
        
        @hl = hl # HighLine

        msg = <<-eom
Auto Configure Shell

This shell allows you to make changes to your current configuration. See
https://github.com/Auto/Auto/wiki/Auto-Configure for guidance.
        eom
        puts msg.yellow

        # Check for ~/.config/autobot/auto.yml
        puts ">> I am looking for your configuration file.....".blue
        path = nil
        if File.exists? File.join Auto::Configure::AUTODIR, 'auto.yml'
          puts ">> I found #{File.join(Auto::Configure::AUTODIR, 'auto.yml').bold}!".green
          path = File.join Auto::Configure::AUTODIR, 'auto.yml'
        end

        if path.nil?
          
          puts ">> Sorry. I could not find your configuration file.".red
          path = ask_for_config

        else
          
          unless @hl.agree("#$S Should I use this configuration?  ") { |q| q.default = 'y' }
            path = ask_for_config
          end

        end

        data = nil
        File.open(path) { |f| data = f.read }

        # Parse it with ol' YAML Ain't Markup Language.
        @conf = YAML.parse(data).to_ruby

        @init = true
        
      end

      # A wrapper for {#go_without_safety} with safety.
      def go
        begin
          go_without_safety
        rescue => e
          puts e.backtrace
          puts "Auto Configure Shell has suffered an error. Closing shell...".red.bold
          exit 1
        end
      end

      # Begin.
      def go_without_safety

        # Produce le menu.
        @hl.choose do |menu|
          puts ">> See 'help' for assistance using this shell.".green unless @init == false
          @init = false

          menu.shell  = true
          menu.prompt = ">> Please enter an action:  "

          # add all of our commands
          COMMANDS.each_pair do |cmd, help|
            menu.choice(cmd, help) { act cmd }
          end

          menu.choice(:help, "Display help.") do |cmd, data|
            
            p data
            args = data.split(/\s+/)
            p args
            if args.length < 1
              puts ">> See https://github.com/Auto/Auto/wiki/Auto-Configure for help using this utility.".green
              puts ">> Command list:".green
              COMMANDS.each_pair { |c, h| puts "- #{c}: #{h}".yellow }
            else
              if COMMANDS.include? args[0]
                puts ">> Help for #{args[0].bold}:".green
                puts COMMANDS[args[0]].yellow
              else
                puts ">> No help available for #{args[0].bold}!".red
              end
            end
            
            go

          end

        end

      end

      # Act.
      def act(cmd)

        case cmd

        when 'lib.add'
          
        when 'lib.ls'

        when 'lib.rm'

        end

        go

      end # def act

      #######
      private
      #######

      def ask_for_config
        path = @hl.ask("#$S Where is your configuration file?  ") { |q| q.default = 'conf/auto.yml' }
        until File.exists? path
          puts ">> Sorry. That does not appear to exist.".red
          path = @hl.ask("#$S Where is your configuration file?  ") { |q| q.default = 'conf/auto.yml' }
        end
        path
      end

    end # class Shell

  end # class Configure

end # class Auto

# vim: set ts=4 sts=2 sw=2 et:
