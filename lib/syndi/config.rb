# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'psych'
require 'syndi/verbosity'
require 'libsyndi'

# Namespace: Syndi
module Syndi

  # A class which provides a functional, simple configuration interface. It uses
  # YAML by means of Psych.
  #
  # @api Syndi
  # @since 4.0.0
  # @author noxgirl
  # @author swarley
  #
  # @!attribute conf
  #   @return [Hash{}] This is the hash which contains the data parsed from
  #     the configuration file.
  #   @see #[]
  class Config
    
    attr_reader :conf, :type

    # Produce a new instance, and attempt to parse.
    #
    # @param [String] filepath Path to configuration file.
    def initialize filepath
      $m.verbose("Trying to initialize configuration from '#{filepath}'...", VSIMPLE) do
        @path = filepath
        parse
      end # verbose
    end

    # Rehash the configuration.
    #
    # If an error occurs, it will revert the configuration to its prior state
    # so that everything can continue to function.
    def rehash!
      
      $m.debug("Configuration file is rehashing.")

      # Keep the old configuration in case of issues.
      oldconf = @conf
      @conf   = {}

      # Rehash
      parse!

      # Ensure it really succeeded.
      if @conf.empty? or !@conf.instance_of? Hash
        # Nope. Restore old configuration.
        @conf = oldconf
        $m.error 'Failed to rehash the configuration file (parser produced empty config)! Reverting to old configuration.'
        return 0
      end
      
      $m.events.call :rehash

    # This rescue is applicable to anything that happens in here, since if it is reached, there really was an error in general.
    rescue => e 
      $m.error 'Failed to rehash configuration file! Reverting to old configuration.', false, e.backtrace
      @conf = oldconf
      return 0
    end

    # Return value of @conf[key].
    #
    # @return [Object] Value of @conf[key].
    # @see @conf
    def [] key
      @conf[key]
    end

    #######
    private
    #######

    # Parse the configuration file, and output the data to {#x}.
    #
    # @raise [ConfigError] If the file does not exist.
    # @raise [ConfigError] If the file cannot be processed.
    def parse

      # Ensure foremost that the configuration file exists.
      unless File.exists? @path
        raise ConfigError, "Configuration file '#@path' does not exist!"
      end

      # Get the data from the file.
      f    = File.open(@path)
      data = f.read
      f.close

      conf = {}
      # Process the YAML.
      begin
        conf = Psych.load data
      rescue => e
        raise ConfigError, "Failed to process the YAML in '#@path'", e.backtrace
      end

      @conf = conf

    end # def parse

  end # class Config

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
