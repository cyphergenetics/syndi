# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require(File.join(File.expand_path(File.dirname(__FILE__)), 'helper.rb'))

require 'auto/config'

describe "A configuration using YAML" do

  YAML_ORIGINAL_CONF = <<EOF
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

  YAML_NEW_CONF = <<EOF
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

  bunny:
  - unimaginable cuteness that forces you to coo

EOF

  YAML_BAD_CONF = <<EOF
THIS ARE RUBBISH

THAT W!LL F41L

...0R SHOULD
EOF

  YAML_HASH_ORIGINAL = {
                  'foo' => {
                            'cat'      => ['meow', 'purr'],
                            'cow'      => ['moo'],
                            'dinosaur' => ['rawr']
                           }
                }

  YAML_HASH_NEW      = {
                  'foo' => {
                            'cat'      => ['meow', 'purr'],
                            'cow'      => ['moo'],
                            'dinosaur' => ['rawr'],
                            'bunny'    => ['unimaginable cuteness that forces you to coo']
                           }
                }

  before do
    $m.should.receive(:debug)
    File.open('.temp.yaml_config.yml', 'w') do |io|
      io.write YAML_ORIGINAL_CONF
    end
    
    @conf = Auto::Config.new('.temp.yaml_config.yml')
    $m.spec_reset
  end

  it 'should have a type of YAML' do
    @conf.type.should.equal :yaml
  end

  it 'should have @conf, a Hash' do
    @conf.conf.class.should.equal Hash
  end

  it 'should have #x, a pointer to @conf' do
    @conf.x.should.be.same_as @conf.conf
  end

  it 'should point [x] to @conf[x]' do
    @conf['foo'].should.be.same_as @conf.conf['foo']
  end

  it 'should have correctly processed data' do
    @conf.x.should.equal YAML_HASH_ORIGINAL
  end

  it 'should rehash on rehash!()' do
    $m.should.receive(:debug)
    $m.should.receive(:events).times(2)
    $m.events.should.receive(:call)

    File.open('.temp.yaml_config.yml', 'w') do |io|
      io.write YAML_NEW_CONF
    end
    @conf.rehash!
    @conf.x.should.equal YAML_HASH_NEW
  end

  it 'should fail on rehash!() if data is bad' do
    $m.should.receive(:debug)
    $m.should.receive(:error)
    File.open('.temp.yaml_config.yml', 'w') do |io|
      io.write YAML_BAD_CONF
    end
    @conf.rehash!.should.equal 0
  end

  it 'should should revert to old data if rehash!() fails' do
    $m.should.receive(:error)
    $m.should.receive(:debug)
    
    File.open('.temp.yaml_config.yml', 'w') do |io|
      io.write YAML_BAD_CONF
    end
    @conf.rehash!
    @conf.x.should.equal YAML_HASH_ORIGINAL
  end

  after do
    File.delete '.temp.yaml_config.yml'
    $m.spec_reset
  end
    
  File.delete '.temp.yaml_config.yml'

end
