#!/usr/bin/env ruby
# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'mkmf'

EXT         = 'libauto'

LIBAUTO_DIR = File.expand_path(File.join('..', '..', '..', 'include'), __FILE__)
unless Dir.exists? LIBAUTO_DIR
  STDERR.puts "libauto headers are missing; your copy of Auto is most probably broken."
  exit 1
end

$CFLAGS << " -Wno-unused-function"
$CFLAGS << " -I#{LIBAUTO_DIR}"

create_makefile EXT

# vim: set ts=4 sts=2 sw=2 et:
