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
      
      # Define @plugins as an array
      @plugins = []

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
        rescue => e
          $m.error("Unable to load plugin #{piname} owing to an unknown exception!", false, e)
        end
      else
        $m.error("Unable to load plugin #{piname} because I cannot find the plugin's main class!")
      end

      # Append to the list of loaded plugins.
      @plugins << {
                'name' => piclass._name,
                'object' => piclass
                }

      # Successful.
      $m.info("Successfully initialized #{piclass._name}!")

    end # def pload

    #****************************
    # TODO: unload()
    ################

  end # class Extender

end # module API
