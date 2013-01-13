# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).
autoload :JSON, 'json'
autoload :YAML, 'psych' # use Psych for YAML not Syck
require 'auto/exceptions'

# Namespace: Auto
module Auto

  # A class which provides a functional, simple configuration interface. It is
  # very useful, as it supports both YAML and JSON for configuration. It
  # determines which is appropriate by looking at file extensions.
  #
  # @api Auto
  # @since 4.0.0
  # @author noxgirl
  # @author swarley
  #
  # @!attribute conf
  #   @return [Hash{}] This is the hash which contains the data parsed from
  #     the configuration file.
  #   @see #[]
  #
  # @!attribute type
  #   @return [Symbol] Type of configuration: +:yaml+ or +:json+.
  class Config
    
    attr_reader :conf, :type

    # Produce a new instance, and attempt to parse.
    #
    # @param [String] filepath Path to configuration file.
    #
    # @raise [ConfigError] If the file extension is not recognized (should be +.yml+ or +.json+).
    def initialize(filepath)

      $m.debug("Trying to initialize configuration from '#{filepath}'...")

      # Set path to file.
      @path = filepath
      
      # Determine the type: YAML or JSON.
      case File.extname(filepath)
      when ".yml"
        @type = :yaml
      when ".json"
        @type = :json
      else
        raise ConfigError, "Unknown file type on #{filepath}."
      end

      # Process the configuration.
      parse!
    
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
      if @conf.empty? or @conf.class != Hash
        # Nope. Restore old configuration.
        @conf = oldconf
        $m.error("Failed to rehash the configuration file (parser produced empty config)! Reverting to old configuration.")
        return 0
      end
      
      # bot:onRehash
      $m.events.call('bot:onRehash')

    # This rescue is applicable to anything that happens in here. Since if it is reached, there really was an error in general.
    rescue => e 
      $m.error("Failed to rehash configuration file! Reverting to old configuration.", false, e.backtrace)
      @conf = oldconf
      return 0
    end

    # Return value of @conf[key].
    #
    # @return [Object] Value of @conf[key].
    # @see @conf
    def [](key)
      @conf[key]
    end

    #######
    private
    #######

    # A constant for detecting comments and strings in JSON files
    COMMENT_REGEXP = %r{(?:/\'(?:[^\'\\]|\\.)*\')|(?:\"(?:[^\"\\]|\\.)*\")|(?://.*\n)|(?:/\*(?m-ix:.)+?\*/)}

    # Strip comments from JSON configuration text. This will not preserve
    # the string passed to it.
    #
    # @argument [String] text The configuration data to strip.
    #
    # @return [String] The stripped configuration text.
    def strip_js_comments!(text)
      # Output string
      out = ""
      until (match_data = text.match(COMMENT_REGEXP)).nil?
        off = match_data.offset(0)
        # Check to see if it starts with /, if so then return up to the lower limit, otherwise to the upper.
        out << text[0...off[(match_data.to_s[0] != '/') ? 1 : 0]]
        # Delete the text that we were dealing with.
        text[0...off[1]] = ''
      end
      # Append anything left
      text = (out << text)
    end

    # The same as strip_js_comments! with original string preservation.
    # @see strip_js_comments!
    def strip_js_comments(text)
      # Preserve
      strip_js_comments!(text.clone)
    end

    # Parse the configuration file, and output the data to {#x}.
    #
    # @raise [ConfigError] If the file does not exist.
    # @raise [ConfigError] If the file cannot be processed.
    def parse!

      # Ensure foremost that the configuration file exists.
      unless File.exists? @path
        raise ConfigError, "Configuration file '#@path' does not exist!"
      end

      # Get the data from the file.
      f = File.open(@path)
      data = f.read
      f.close

      conf = {}
      # JSON
      if @type == :json

        # Strip comments out of the data.
        data = strip_js_comments!(data)

        # Process the JSON.
        begin 
          conf = JSON.parse(data)
        rescue => e
          raise ConfigError, "Failed to process the JSON in '#@path'", e.backtrace
        end

      else # Must be YAML
        
        # Process the YAML.
        begin
          y = YAML.parse(data)
          conf = y.to_ruby
        rescue => e
          raise ConfigError, "Failed to process the YAML in '#@path'", e.backtrace
        end

      end

      @conf = conf

    end # def parse

  end # class Config

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
