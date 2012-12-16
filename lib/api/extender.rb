# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Namespace: API
module API

  # Class: Extender
  #
  # This API::Extender class is intended to provide a means by which plugins
  # may enter the runtime.
  class Extender

    attr_reader :plugins 

    # Create new API::Extender instance.
    def initialize
      
      # Define @plugins as a hash
      @plugins = {}

    end

    # Load a plugin.
    def pload(piname)

      # Ensure foremost that the associated source file exists.
      unless File.exists? "plugins/#{piname.dc}.rb"
        $m.error("Unable to load plugin #{piname} because plugins/#{piname.dc}.rb does not exist!")
        return
      end
      
      # Try to prevent duplicates.
      if @plugins.include? piname.dc
        $m.error("Initializing #{piname}: Duplicate (#{piname.dc}) exists! Halting initialization...")
        return
      end

      # Check this file for plugin_class. We need to know what the plugin's class is,
      # or we can't initialize it.
      f = File.new("plugins/#{piname.dc}.rb")
      d = f.read
      f.close
      match = %r{^#\splugin_class:\s(\S+)$}.match(d)
      piclass = nil
      # Try to initialize?
      if match.length > 0
        begin
          load "plugins/#{piname.dc}.rb"
          eval "piclass = #{match[1]}.new"
        rescue RuntimeError => e
          $m.error("Unable to load plugin #{piname} owing to RuntimeError!", false, e)
          return
        rescue => e
          $m.error("Unable to load plugin #{piname} owing to an unknown exception!", false, e)
          return
        end
      else
        $m.error("Unable to load plugin #{piname} because I cannot find the plugin's main class!")
        return
      end

      # Append to the list of loaded plugins.
      @plugins[piclass._name.dc] = {}
      @plugins[piclass._name.dc][:object] = piclass
      eval "@plugins[piclass._name.dc][:class] = #{match[1]}"

      # Successful.
      $m.info("Successfully initialized #{piclass._name}!")
      $m.events.call('bot:onLoadPlugin', piclass._name)

    end # def pload

    # Unload a plugin (public method).
    def punload(piname)

      # Check if it's really loaded.
      unless @plugins.include? piname.dc
        $m.error("Unable to unload #{piname} because no such plugin is loaded!")
        return
      end

      # Call the private method.
      _unload(@plugins[piname.dc][:object], @plugins[piname.dc][:class])

    end

    #######
    private
    #######

    # Unload a plugin.
    def _unload(object, oclass)

      # Foremost, attempt to call uninitialize()
      name = object._name
      begin
        object.uninitialize
      rescue NameError => e
        $m.error("Unloading plugin #{name}: uninitialize() method is missing! (NameError) Serious issues could occur.", false, e)
      rescue => e
        $m.error("Unloading plugin #{name}: uninitialize() call raised an exception! Serious issues could occur.", false, e)
      ensure
        # Whatever the outcome, we must destroy the plugin.
        if @plugins.include? name
          if @plugins[name.dc][:object] == object
            @plugins.delete(name.dc)
          end
        end
        $m.events.call('bot:onUnloadPlugin', name)
      end
    
    end # def _unload

  end # class Extender

end # module API
