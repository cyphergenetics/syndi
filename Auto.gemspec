# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

$:.unshift './lib'
require 'auto/version'

Gem::Specification.new do |s|
  
  s.name    = 'Auto'
  s.version = "#{Auto::VERSION}"

  s.date          = Time.now.strftime '%Y-%m-%d'
  s.summary       = 'A modern, elegant, extensible multi-protocol bot.'
  s.description   = <<-EOD
    An elegant, modern, multithreaded, event-driven, modular, chat bot
    designed upon a multi-protocol model.
  EOD
  s.authors       = [
    'Autumn Perrault',
    'Matthew Carey'
  ]
  s.email         = 'autobot-talk@googlegroups.com'
  s.homepage      = 'http://autoproj.org'
  s.license       = 'FreeBSD'

  s.files         = Dir["{bin,lib,ext,docs,include,tasks}/**/*"] + %w[
    README.md
    LICENSE
    WINDOWS.md
    INSTALL.md
    CHANGELOG.md
    Gemfile
    Rakefile
    .yardopts
    conf/example.yml
  ]
  s.test_files    = Dir["spec/**/*"] + ['Rakefile']
  s.executables   = %w[auto auto-conf]
  s.extensions    = Dir["ext/**/extconf.rb"]

  s.post_install_message  = <<-EOM
Thanks for choosing Auto to serve your chat bot needs! (:

We suggest that, if you're not already consulting it, you read the Auto Handbook:
https://github.com/Auto/Auto/wiki/Handbook

Moreover, you should typically now run `auto-conf` to produce a configuration file.
  EOM

  s.add_runtime_dependency 'celluloid',    '~> 0.12'
  s.add_runtime_dependency 'celluloid-io', '~> 0.12'
  s.add_runtime_dependency 'colored',      '~> 1.2'
  s.add_runtime_dependency 'redis',        '~> 3.0'
  s.add_runtime_dependency 'slop',         '~> 3.4'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'rspec', '~> 2.12'

end

# vim: set ts=4 sts=2 sw=2 et:
