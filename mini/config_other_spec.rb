# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (see LICENSE).
require(File.join(File.expand_path(File.dirname(__FILE__)), 'helper.rb'))

require 'auto/config'

describe "A base configuration" do

  before do
    $m.expects(:debug)
  end

  it 'should raise ConfigError on initialize if a non-existent file was provided' do
    -> { Auto::Config.new('.temp.file_no_exist.yml') }.must_raise ConfigError
  end

end

# vim: set ts=4 sts=2 sw=2 et:
