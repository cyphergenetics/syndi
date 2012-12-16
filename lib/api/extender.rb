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
          eval "piclass = #{match[1]}.new", nil, ">/dev/null"
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

      # Ensure we don't have duplicates.
      if @plugins.include? piclass._name
        $m.error("Initializing #{piname}: plugin initialized, but duplicate (#{piclass._name}) exists! Forcing out of runtime...")
        unload(piclass)
        return
      end


      # Append to the list of loaded plugins.
      @plugins[piclass._name][:object] = piclass
      eval "@plugins[piclass._name][:class] = #{match[1]}"

      # Successful.
      $m.info("Successfully initialized #{piclass._name}!")
      $m.events.call('bot:onLoadPlugin', piclass._name)

    end # def pload

    # Unload a plugin (public method).
    def punload(piname)

      # Check if it's really loaded.
      unless @plugins.include? piname
        $m.error("Unable to unload #{piname} because no such plugin is loaded!")
        return
      end

      # Call the private method.
      unload(@plugins[piname][:object], @plugins[piname)

    end

    #######
    private
    #######

    # Unload a plugin.
    def unload(object, oclass)

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
        eval "undef #{oclass}"
        if @plugins.include? name
          if @plugins[name][:object] == object
            @plugins.delete(name)
          end
        end
        $m.events.call('bot:onUnloadPlugin', name)
      end
    
    end


  end # class Extender

end # module API
