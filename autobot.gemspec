# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'auto'

Gem::Specification.new do |s|
  
  s.name    = 'autobot'
  s.version = Auto::VERSION

  s.date          = Time.now.strftime '%Y-%m-%d'
  s.summary       = 'An advanced, automated multi-protocol bot which uses plugins.'
  s.description   = <<-EOD
    A simple and smart multi-protocol bot (currently supports IRC) which allows for
    easy extension by means of its plugin API.
  EOD
  s.authors       = %w[
    noxgirl
    swarley
  ]
  s.email         = 'autobot-talk@googlegroups.com'
  s.homepage      = 'http://auto.autoproj.org'
  s.license       = 'FreeBSD'

  s.files         = Dir.glob("{bin,lib,docs}/**/*") + %w[
    README.md
    LICENSE.md
    Gemfile
    .yardopts
  ]
  s.test_files    = Dir.glob("spec/**/*") + ['Rakefile']
  s.executables   = %w[auto auto-conf]

  s.required_ruby_version = '>= 1.9.2'
  s.post_install_message  = <<-EOM
    Thanks for installing Auto!

    We suggest that, if you're not already consulting it, you read the installation guide:
    https://github.com/Auto/Auto/wiki/Install-Guide

    Moreover, you should typically now run `auto-conf` to produce a configuration file.
  EOM

  s.add_runtime_dependency 'colored',  '>= 1.2'
  s.add_runtime_dependency 'sequel',   '>= 3.42'
  s.add_runtime_dependency 'highline', '>= 1.6'
  
  s.add_development_dependency 'rake',           '>= 0.9'
  s.add_development_dependency 'bacon',          '>= 1.2'
  s.add_development_dependency 'mocha',          '>= 0.13'
  s.add_development_dependency 'mocha-on-bacon', '>= 0.2'

end

# vim: set ts=4 sts=2 sw=2 et:
