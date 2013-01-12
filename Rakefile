# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'rake/testtask'
require 'rake/extensiontask'

# Directives for Ruby Make (rake)
# to test/compile Auto 4, and optionally
# push to RubyGems

task :default => [:compile, :test]
task :gem     => [:default, :make_gem, :release_gem]

Rake::ExtensionTask.new 'libauto'

desc 'Test the application.'
task :test do
  Rake::TestTask.new do |t|
    t.libs.push 'lib'
    t.pattern = 'spec/*_spec.rb'
    t.verbose = true
  end
end
  
desc 'Construct a gem from the gemspec.'
task :make_gem do
  sh "gem build #{Dir["*.gemspec"].first}"
end

desc 'Install the gem to the system.'
task :install => :make_gem do
  sh "gem install #{Dir["*.gem"].last}"
end

desc 'Push this gem release to RubyGems.'
task :release_gem => :make_gem do
  sh "gem push #{Dir["*.gem"].last}"
end

# vim: set ts=4 sts=2 sw=2 et:
