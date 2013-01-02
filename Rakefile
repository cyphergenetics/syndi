# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

# Directives for Ruby Make (rake)
# to test/compile Auto 4

task :default => [:testing]
task :gem => [:default, :make_gem, :release_gem]

desc "Test the application"
task :testing do 
  inc   = "-i lib"
  tests = [ File.join(%w[ spec *spec.rb ]) ]
  
  tests.each do |t|
    sh "bacon #{inc} #{t}"
  end

end

desc "Create a gem from the gemspec."
task :make_gem do
  sh "gem build #{Dir["*.gemspec"].first}"
end

desc "Install the gem"
task :install => :make_gem do
  sh "gem install #{Dir["*.gem"].last}"
end

desc "Push this release to rubygems."
task :release_gem => :make_gem do
  sh "gem push #{Dir["*.gem"].last}"
end

# vim: set ts=4 sts=2 sw=2 et:
