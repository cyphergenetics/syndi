# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

desc 'Install the gem.'
task :install => :gem do
  gempkg = Dir["pkg/Syndi-#{$gemspec.version}.gem"].last
  sh "gem install #{gempkg}"
end

# vim: set ts=4 sts=2 sw=2 et:
