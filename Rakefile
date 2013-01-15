# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

require 'rake/testtask'
require 'rake/extensiontask'
require 'rubygems'
require 'rubygems/package_task'

# import the gemspec
GEMSPEC = 'Auto.gemspec'
gemspec ||= eval(File.read(GEMSPEC), binding, GEMSPEC)

# Directives for Ruby Make (rake)
# to test/compile Auto 4, and optionally
# push to RubyGems

task :default => [:compile, :test]
task :full    => [:clean, :default, :gem, :install]

desc 'Compile the native extension.'
Rake::ExtensionTask.new 'libauto', gemspec do |ext|
  ext.cross_compile = true

  ext.cross_compiling do |spec|
    spec.post_install_message << "\r\nNOTICE: You have installed the binary distribution of this gem."
  end
end

desc 'Test the application.'
Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.pattern = 'spec/*_spec.rb'
  t.verbose = true
end

desc 'Package the gem.'
Gem::PackageTask.new(gemspec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

desc 'Install the gem.'
task :install => :gem do
  gempkg = Dir["pkg/Auto-#{gemspec.version}.gem"].last
  sh "gem install #{gempkg}"
end
 
# vim: set ts=4 sts=2 sw=2 et:
