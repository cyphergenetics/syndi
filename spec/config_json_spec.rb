# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.
require 'bacon'
require 'spec/test_helpers'

require 'auto/config'

describe "A configuration using JSON" do

  JSON_ORIGINAL_CONF = <<EOF
{
    // This is a comment; swarley+noxgirl=<3
    "foo": {
            "cat": ["meow","purr"],
            "cow": ["moo"/* my loveybear wrote a really cool regexp that strips these comments*/],
            "dinosaur": /* weirdly placed comments ftw */ ["rawr"]
           }
}
EOF

  JSON_NEW_CONF = <<EOF
{
    // This is a comment; swarley+noxgirl=<3
    "foo": {
            "cat": ["meow","purr"],
            "cow": ["moo"/* my loveybear wrote a really cool regexp that strips these comments*/],
            "dinosaur": /* weirdly placed comments ftw */ ["rawr"],
            "bunny": /* OMG BUNNIES <3 */ ["unimaginable cuteness that forces you to coo"]
           }
}
EOF

  JSON_BAD_CONF = <<EOF
THIS ARE RUBBISH

THAT W!LL F41L

...0R SHOULD
EOF

  JSON_HASH_ORIGINAL = {
                  'foo' => {
                            'cat'      => ['meow', 'purr'],
                            'cow'      => ['moo'],
                            'dinosaur' => ['rawr']
                           }
                }

  JSON_HASH_NEW      = {
                  'foo' => {
                            'cat'      => ['meow', 'purr'],
                            'cow'      => ['moo'],
                            'dinosaur' => ['rawr'],
                            'bunny'    => ['unimaginable cuteness that forces you to coo']
                           }
                }

  before do
    File.open('.temp.json_config.json', 'w') do |io|
      io.write JSON_ORIGINAL_CONF
    end
    
    @conf = Auto::Config.new('.temp.json_config.json')
  end

  it 'should have a type of JSON' do
    @conf.type.should.equal :json
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
    @conf.x.should.equal JSON_HASH_ORIGINAL
  end

  it 'should rehash on rehash!()' do
    File.open('.temp.json_config.json', 'w') do |io|
      io.write JSON_NEW_CONF
    end
    @conf.rehash!
    @conf.x.should.equal JSON_HASH_NEW
  end

  it 'should fail on rehash!() if data is bad' do
    File.open('.temp.json_config.json', 'w') do |io|
      io.write JSON_BAD_CONF
    end
    @conf.rehash!.should.equal 0
  end

  it 'should should revert to old data if rehash!() fails' do
    File.open('.temp.json_config.json', 'w') do |io|
      io.write JSON_BAD_CONF
    end
    @conf.rehash!
    @conf.x.should.equal JSON_HASH_ORIGINAL
  end

  after do
    File.delete '.temp.json_config.json'
  end
    
  File.delete '.temp.json_config.json'

end
