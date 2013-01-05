# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

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
        @hl = hl

        msg = <<-eom
Auto Configure Shell

This shell allows you to make changes to your current configuration. See
https://github.com/Auto/Auto/wiki/Auto-Configure for guidance.
        eom
        puts msg.yellow

        # Check for ~/.config/autobot/auto.yml
        puts ">> I am looking for your configuration file.....".blue
        path = nil
        if File.exists Auto::Configure::AUTODIR
          puts ">> I found #{Auto::Configure::AUTODIR.bold}!".green
          path = Auto::Configure::AUTODIR.bold
        end

        if path.nil?
          
        end
        
      end

      # Begin.
      def go

        # Produce le menu.
        @hl.choose do |menu|
          puts ">> See 'help' for assistance using this shell.".green

          menu.prompt ">> Please enter an action:  "

          # add all of our commands
          COMMANDS.each_pair do |cmd, help|
            menu.choice(cmd, help) { act cmd }
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

      end # def act

    end # class Shell

  end # class Configure

end # class Auto

# vim: set ts=4 sts=2 sw=2 et:
