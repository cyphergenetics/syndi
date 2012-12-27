# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.
require 'bacon'
require 'spec/auto/auto'
require 'auto/config'

$m = Spec::Auto::Auto.new

describe "A new Auto::Config using YAML" do

  before do
    File.open('.temp.yaml_config.yml', 'w') do |io|
      io.write <<EOF
---
# This is a comment; unicorns are lovely
foo:

  cat:
  - meow
  - purr

  cow:
  - moo

  dinosaur:
  - rawr
      
EOF
    end
    
    @conf = Auto::Config.new('.temp.yaml_config.yml')
  end

  it 'should have a type of YAML' do
    @conf.type.should.equal :yaml
  end

  it 'should have @conf, a Hash' do
    @conf.conf.class.should.equal Hash
  end

  it 'should have #x, a pointer to @conf' do
    @conf.x.should.equal @conf.conf
  end

  it 'should have correctly processed data' do
    @conf.x.should.equal('foo' => {
                            'cat'      => ['meow', 'purr'],
                            'cow'      => ['moo'],
                            'dinosaur' => ['rawr']
                          }
                        )
  end

  it 'should rehash on rehash!()' do
  end

  it 'should have successfully updated @conf after rehash!()' do
  end

  it 'should fail to rehash!() if data is bad' do
  end

  it 'should revert to old data if rehash!() fails' do
  end

  after do
    File.delete('.temp.yaml_config.yml')
  end

end
