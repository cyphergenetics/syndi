#!/usr/bin/env ruby
# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'mkmf'

EXT         = 'csyndi'

LIBSYNDI_DIR = File.expand_path(File.join('..', '..', '..', 'include'), __FILE__)
unless Dir.exists? LIBSYNDI_DIR
  STDERR.puts "csyndi headers are missing; your copy of Syndi is most probably broken."
  exit 1
end

$CFLAGS << " -Wno-unused-function"
$CFLAGS << " -I#{LIBSYNDI_DIR}"

create_makefile EXT

# vim: set ts=4 sts=2 sw=2 et:
