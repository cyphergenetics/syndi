# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'rspec/core/rake_task'

desc 'Test the application.'
RSpec::Core::RakeTask.new do |t|
  t.pattern    = "#{__dir__}/../spec/**/*_spec.rb"
  t.rspec_opts = ["-I #{__dir__}/../lib", "-r #{__dir__}/../spec/helper.rb"]
end

# vim: set ts=4 sts=2 sw=2 et:
