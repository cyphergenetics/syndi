# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

################################################################
# API::Plugin
#
# A class intended to operate as a basic superclass for plugins.
################################################################

# Namespace: API
module API
  
  # Class: Plugin
  # Intended as a superclass for plugins
  class Plugin

    attr_reader :_name, :_version, :_summary, :_deps

    def initialize(name, version, summary, deps)
      @_name = name
      @_version = version
      @_summary = summary
      deps.each do |dep|
        unless $m.mods.include?(dep)
          raise RuntimeError, "#@name cannot load because dependency '#{dep}' is missing"
        end
      end
      @_deps = deps
    end

    def to_s
      @_name
    end

  end # class Plugin

end # module API

# vim: set ts=4 sts=2 sw=2 et:
