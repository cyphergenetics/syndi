# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

Gem::Specification.new do |s|
  
  s.name          = 'autobot'
  s.version       = '4.0.0d'
  s.date          = '2013-01-01'
  s.summary       = 'An advanced, automated multi-protocol bot which uses plugins.'
  s.description   = <<EOD
A simple and smart multi-protocol bot (currently supports IRC) which allows for
easy extension by means of its plugin API.
EOD
  s.authors       = ['noxgirl', 'swarley']
  s.email         = 'autobot-talk@googlegroups.com'
  s.homepage      = 'http://auto.autoproj.org'
  s.license       = 'FreeBSD'

  s.files         = %w[
    README.md
    LICENSE.md
    Gemfile
    Rakefile
  ] + Dir['doc/*'] + Dir['lib/**/*.rb'] + Dir['bin/*']
  s.bindir        = 'bin'
  s.executables   = ['auto', 'auto-conf']

  s.required_ruby_version = '>= 1.9.2'
  s.post_install_message  = <<EOM
Thanks for installing Auto!

We suggest that, if you're not already consulting it, you read the installation guide.
Moreover, you should typically now run `auto-conf` to make a configuration file.
EOM

end

# vim: set ts=4 sts=2 sw=2 et:
