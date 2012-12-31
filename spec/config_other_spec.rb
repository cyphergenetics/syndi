# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require 'bacon'
require 'spec/test_helpers'

require 'auto/config'

describe "A base configuration" do

  it 'should raise ConfigError on initialize if a non-existent file was provided' do
    should.raise(ConfigError) { Auto::Config.new('.temp.file_no_exist.yml') }
  end

  it 'should raise ConfigError on initialize if the file\'s extension is not recognized' do
    File.open('.temp.xml_config.xml', 'w') do |io|
      io.write "<title>Hello world</title>"
    end

    should.raise(ConfigError) { Auto::Config.new('.temp.xml_config.xml') }
  end

  File.delete '.temp.xml_config.xml'

end

# vim: set ts=4 sts=2 sw=2 et:
