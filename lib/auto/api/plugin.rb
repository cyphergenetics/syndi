# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'ostruct'
require 'auto/exceptions'
require 'auto/bot'

module Auto

  module API

    # A basic superclass for plugins.
    #
    # @api Auto
    # @since 4.0.0
    # @author noxgirl
    # @author swarley
    #
    # @!attribute [r] name
    #   @return [String] Name of the plugin.
    #
    # @!attribute [r] summary
    #   @return [String] Summary of the plugin.
    #
    # @!attribute [r] version
    #   @return [String] Version of the plugin.
    #
    # @!attribute [r] library
    #   @return [String] The library upon which the plugin is based.
    #
    # @!attribute [r] author
    #   @return [String] Author of the plugin.
    #
    # @!attribute [r] auto
    #   @return [String] Version of Auto required by the plugin.
    class Plugin

      attr_reader :name, :summary, :version, :library, :author, :auto

      # Configure the plugin.
      #
      # @yieldparam [OpenStruct] conf Configuration structure.
      #
      # - +conf.name+: Name of the plugin (String).
      # - +conf.summary+: Summary of the plugin (String).
      # - +conf.version+: Version of the plugin (String).
      # - +conf.library+: Library upon which the plugin is based. (String).
      # - +conf.author+: Author of the plugin (String).
      # - +conf.auto+: Required version of Auto (String). Should be in the format of
      #   +'~> version'+ or +'>= version'+. +~>+ means at least +version+ but no later
      #   than the minor version (e.g. +'~> 4.0'+ will allow +4.0.2+ but not +4.1.0+).
      #   +>=+ means at at least +version+.
      #
      # Additionally, it should be noted that +conf.library+ should be either of the
      # core libraries, *or* 'multi' if it uses multiple libraries.
      #
      # @example
      #   configure do |c|
      #     c.name    = 'MagicPlugin'
      #     c.summary = 'A magical extension.'
      #     c.version = '1.00'
      #     c.library = 'irc'
      #     c.author  = 'noxgirl'
      #     c.auto    = '~> 4.0'
      #   end
      def configure

        # Prepare an open structure.
        conf = OpenStruct.new

        # Yield it to the configuration block.
        yield conf if block_given?

        # Check for sufficient configuration.
        [:name,:summary,:version,:library,:author,:auto].each do |s|
          if conf.send(s).nil?
            raise PluginError, "Plugin #{self.inspect} provided insufficient configuration (#{s} is nil)."
          end
        end

        @name    = conf.name
        @summary = conf.summary
        @version = conf.version
        @library = conf.library
        @author  = conf.author

        # Check for compatibility.
        if conf.auto =~ /^(~>\s*)((?:[\dabcr])(?:\.[\dabcr]))+$/ # ~>
        
          ver = $2
          if Gem::Version.new(ver.dup) >= Gem::Version.new(Auto::VERSION.dup) # must be later than or equal to current
            
            # Split current version and plugin-demanded version by '.'.
            verarr  = Auto::VERSION.split(/\./)
            pverarr = ver.split(/\./)

            # Must be no later than the current minor version
            unless verarr[1] <= pverarr[1]
              raise PluginError, "Plugin #@name v#@version demands Auto #{conf.auto}; current version is #{Auto::VERSION}. Incompatible! Aborting load!"
            end

            @auto = conf.auto
          
          else
            raise PluginError, "Plugin #@name v#@version demands Auto #{conf.auto}; current version is #{Auto::VERSION}. Incompatible! Aborting load!"
          end # if ver >=

        elsif conf.auto =~ /^(>=\s*)((?:[\dabcr])(?:\.[\dabcr]))+$/ # >=
        
          ver = $2
          unless ver >= Auto::VERSION # must be later than or equal to current
            raise PluginError, "Plugin #@name v#@version demands Auto #{conf.auto}; current version is #{Auto::VERSION}. Incompatible! Aborting load!"
          end
        
          @auto = conf.auto

        else
          raise PluginError, "Plugin #@name v#@version cannot be checked for compatibility. Aborting load!"
        end # compat check
        
      end # def configure

      #########
      protected
      #########

      # Inheritance event.
      #
      # @param [Class] subklass The subclass which has inherited {self}.
      def self.inherited(subklass)
        $m.debug("[plugin] Auto::API::Plugin inherited by #{subklass}")
      end

    end # class Plugin

  end # module API

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
