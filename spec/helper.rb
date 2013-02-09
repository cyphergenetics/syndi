# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'English'
$LOAD_PATH.unshift File.join __dir__, '..', 'lib'

require 'rspec/core'
require 'rspec/expectations'
require 'rspec/mocks'
require 'fileutils'
require 'stringio'
require 'tmpdir'
    
require 'syndi'

$temp_dir = Dir.mktmpdir 'syndi-rspec'
Syndi.dir = $temp_dir
$VERBOSITY = Float::INFINITY

module Helper

end

RSpec.configure do |conf|
  conf.include Helper

  conf.after(:all) do
    FileUtils.remove_entry $temp_dir
  end

  conf.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# vim: set ts=4 sts=2 sw=2 et:
