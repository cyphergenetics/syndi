# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

module Auto

  class Configure
    
    # A class which allows for interaction with the current configuration,
    # in contrast to generation of an entirely new one.
    class Shell

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

      # Begin.
      def go

        @hl.choose do |menu|
          puts ">> See 'help' for assistance using this shell.".green

          menu.prompt ">> Please enter an action:  "

          # lib add
          menu.choice('lib.add', "Add a library to load.") { act 'lib.add' }

      end

      # Act.
      def act(cmd)

        case cmd

        when 'lib.add'
          

  end



# vim: set ts=4 sts=2 sw=2 et:
