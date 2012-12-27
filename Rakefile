# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

task :default => [:testing]

task :testing do 
  inc   = "-i #{File.join(%w[ spec lib ])} -i lib"
  tests = [ File.join(%w[ spec *spec.rb ]) ]
  
  tests.each do |t|
    sh "bacon #{inc} #{t}"
  end
end
