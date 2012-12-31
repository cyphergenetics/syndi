# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

class Generic < StandardError
end

class ConfigError < Generic
end

class LogError < Generic
end

class DatabaseError < Generic
end

# vim: set ts=4 sts=2 sw=2 et:
