# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Namespace: API
module API
  
  # A standard mixin for plugins to employ.
  #
  # @api Auto
  # @since 4.0.0
  # @author noxgirl
  #
  # @!attribute [r] name
  #   @return [String] The name of the plugin.
  #
  # @!attribute [r] version
  #   @return [Integer] The version of the plugin.
  #
  # @!attribute [r] summary
  #   @return [String] A summary of the plugin.
  #
  # @!attribute [r] deps
  #   @return [Array<String>] A list of modules upon which the plugin depends.
  module Plugin

    attr_reader :name, :version, :summary, :deps

    # Register the plugin's essential data, and check for presence of
    # dependencies.
    #
    # @param [Array<String>] deps List of core modules necessary for operation.
    #
    # @yieldparam [self] c An object for configuration.
    #
    # @example
    #   pi_register(['irc']) do |c|
    #     c.name    = "Foobar plugin"
    #     c.version = 2.1
    #     c.summary = "A plugin for the art of foobar."
    #   end
    def self.pi_register(deps)
      
      @name    = name
      @version = version
      @summary = summary
      # Yield for configuration.
      yield self if block_given? or raise LoadError, "Plugin failed to register because it did not configure itself."

      # Check dependencies.
      deps.each do |dep|
        unless $m.mods.include?(dep)
          raise LoadError, "#@name cannot load because dependency '#{dep}' is missing"
        end
      end
      @deps    = deps
    
    end

    def self.to_s; @name; end

  end # module Plugin

end # module API

# vim: set ts=4 sts=2 sw=2 et:
