# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

desc 'Release a new version.'
task :release, :version do |t, args|

  # Clean up object files, compile, and test.
  perform 'clean'
  perform 'compile'
  perform 'test'



  

end


# vim: set ts=4 sts=2 sw=2 et:
