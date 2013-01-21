# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'rake/extensiontask'

desc 'Compile the native extension.'
Rake::ExtensionTask.new 'libauto', $gemspec do |ext|
  ext.cross_compile  = true

  ext.cross_compiling do |spec|
    spec.post_install_message << "\r\nNOTICE: You have installed the binary distribution of this gem."
  end
end

# vim: set ts=4 sts=2 sw=2 et:
