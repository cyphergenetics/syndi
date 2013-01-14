#!/usr/bin/env ruby
# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'mkmf'

extension = 'libauto'

dir_config extension

$CFLAGS << " -Wno-unused-function "

create_makefile extension

# vim: set ts=4 sts=2 sw=2 et:
