# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'rake/testtask'

desc 'Test the application.'
Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.pattern = 'spec/*_spec.rb'
  t.verbose = true
end

# vim: set ts=4 sts=2 sw=2 et:
