# Copyright (c) 2013, Autumn Perrault. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

$:.unshift './lib'
require 'syndi/version'

Gem::Specification.new do |s|
  
  s.name    = 'syndi'
  s.version = "#{Syndi::VERSION}"

  s.date          = Time.now.strftime '%Y-%m-%d'
  s.summary       = 'A modern, elegant, extensible multi-protocol bot.'
  s.description   = <<-EOD
    An elegant, modern, multithreaded, event-driven, modular chat bot
    designed upon a multi-protocol model.
  EOD
  s.authors       = [
    'Autumn Perrault',
    'Matthew Carey'
  ]
  s.email         = 'syndibot@googlegroups.com'
  s.homepage      = 'http://syndibot.com'
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
  s.executables   = %w[syndi syndi-conf]
  s.extensions    = Dir["ext/**/extconf.rb"]

  s.post_install_message  = <<-EOM
Thanks for choosing Syndi to serve your chat bot needs! (:

We suggest that, if you're not already consulting it, you read the Syndi Handbook:
https://github.com/syndibot/syndi/wiki/Handbook

Moreover, you should typically now run `syndi-conf` to produce a configuration file.
  EOM

  s.add_dependency 'bundler',      '~> 1.2'
  s.add_dependency 'celluloid',    '~> 0.12'
  s.add_dependency 'celluloid-io', '~> 0.12'
  s.add_dependency 'colored',      '~> 1.2'
  s.add_dependency 'redis',        '~> 3.0'
  s.add_dependency 'slop',         '~> 3.4'
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'rspec',        '~> 2.12'

end

# vim: set ts=4 sts=2 sw=2 et:
