# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.
require 'json'

# Namespace: Core
module Core

  # Class: Config
  # Configuration file management.
  class Config

    attr_reader :x

    # Create new instance of Core::Config.
    def initialize(filepath)

      $m.debug("Trying to initialize configuration from '#{filepath}'...")

      # Set path to file.
      @path = filepath
      # Process the configuration.
      parse!
    
    end

    #**************************************
    # Rehash the configuration.
    # TODO while events are worked on

    #######
    private
    #######

    def parse!

      # Ensure foremost that the configuration file exists.
      unless File.exists? @path
        $m.error("Configuration file '#@path' does not exist!")
        return
      end

      # Get the data from the file.
      f = File.open(@path)
      data = f.read
      f.close

      # Strip comments out of the data.
      data.gsub!(/\/\**\*\/|\/\/.[\r]\n/, '')

      # Process the JSON.
      conf = {}
      begin
        conf = JSON.parse!(data)
      rescue => e
        $m.error("Failed to process the JSON in configuration file '#@path'!", false, e)
        return
      end

      @x = conf

    end # def parse

  end # class Config

end # module Core
