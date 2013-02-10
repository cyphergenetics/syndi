# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'fileutils'
require 'tmpdir'
require 'psych'

desc 'Task for release automation.'
task :release, [:version] => [:compile, :spec] do |t, args|
  version = args[:version]

  ## Adjust the version numbers.
  data = ''

  # lib/syndi/version.rb
  File.open(File.join(__dir__, '..', 'lib', 'syndi', 'version.rb')) { |f| data = f.read }
  data.sub! /VERSION = '(.+?)'\.freeze/, "VERSION = '#{version}'.freeze"
  File.open(File.join(__dir__, '..', 'lib', 'syndi', 'version.rb'), 'w') { |f| f.write data }
  
  # README.md
  File.open(File.join(__dir__, '..', 'README.md')) { |f| data = f.read }
  data.sub! /\| \*\*Version:\*\*   \| (.+?)\s"([\w\s]+)"\s+\|/ do |string|
    codename = $2
    new      = "#{version} \"#{codename}\"".ljust 42
    "| **Version:**   | #{new} |"
  end
  File.open(File.join(__dir__, '..', 'README.md'), 'w') { |f| f.write data }

  # CHANGELOG.md
  File.open(File.join(__dir__, '..', 'CHANGELOG.md')) { |f| data = f.read }
  data.sub! /unreleased\n----------/ do |string|
    line = '-'
    version.length.times { line << '-' }
    "v#{version}\n#{line}"
  end
  File.open(File.join(__dir__, '..', 'CHANGELOG.md'), 'w') { |f| f.write data }

  # with that mess out of the way, let's do the git stuff
  Dir.chdir File.join(__dir__, '..')

  `git commit -a -m "Syndi v#{version}"`
  `git tag -a v#{version} -m "Syndi v#{version}"`
  `git push`
  `git push --tags`

  # now package the gem
  perform :clean
  FileUtils.remove_entry File.join(__dir__, '..', 'pkg') if Dir.exists? File.join(__dir__, '..', 'pkg')
  
  perform :gem # first the Ruby gem

  # then the Windows gem
  perform :clean
  `rake cross compile native gem`

  ### NOTE: this is just for me because you can't push gems from prerelease
  ### rubygems, so remove this after 2.0 is released as stable
  ### --Autumn
  `rbenv global system`

  # push the gems
  Dir['pkg/syndi-*.gem'].each do |gem|
    `gem push #{File.expand_path gem}`
  end

  # see note above
  `rbenv global 2.0.0-rc2`

  # clean up
  perform :clean
  FileUtils.remove_entry File.join(__dir__, '..', 'pkg')

  ## now we need to make a blog post ##
  temp = Dir.mktmpdir
  Dir.chdir temp

  `git clone git@github.com:syndibot/syndibot.github.com.git blog`
  Dir.chdir 'blog'

  data = ''
  File.open('_config.yml') { |f| data = f.read }
  info = Psych.load data
  info['versions'].unshift version

  if version < '1'
    info['latest']     = version
    info['latest_pre'] = version
  else
    if version =~ /alpha|beta|pre|rc/
      info['latest_pre'] = version
    else
      info['latest']     = version
    end
  end

  File.open('_config.yml', 'w') { |f| f.write info.to_yaml }
  system './manage', 'post', '--category=releases', "--title=v#{version} released"

  Dir.chdir __dir__
  FileUtils.remove_entry temp

  puts <<-message
    
    Release finished! Syndi #{version} is now available for download.

    If there was need for a codename change, you ought to have already done that.

    In any event, you should probably now notify the mailing list with the link above. (:
    https://groups.google.com/group/syndibot

  message

end

# vim: set ts=4 sts=2 sw=2 et:
