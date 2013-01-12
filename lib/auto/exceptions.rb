# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

class GenericError < StandardError
end

class ConfigError < GenericError
end

class LogError < GenericError
end

class DatabaseError < GenericError
end

class PluginError < GenericError
end

# vim: set ts=4 sts=2 sw=2 et:
