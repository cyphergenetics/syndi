# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'mkmf'

extension = 'auto/logger'

dir_config extension

$CFLAGS << " -I./include/ "

create_makefile extension

# vim: set ts=4 sts=2 sw=2 et:
