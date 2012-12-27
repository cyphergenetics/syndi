# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.
require 'bacon'
require 'spec/test_helpers'

require 'auto/config'

describe "A configuration using JSON" do

  before do
    File.open('.temp.json_config.json', 'w') do |io|
      io.write <<EOF
{
    // This is a comment; unicorns are lovely
    "foo": {
          "cat": ["meow", "purr"],
          "cow": ["moo"],
          "dinosaur": /* Likewise is this weirdly placed comment o; */ ["rawr"]
           }

}
      
EOF
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
    @conf.x.should.equal @conf.conf
  end

  it 'should point [x] to @conf[x]' do
    @conf['foo'].should.equal @conf.conf['foo']
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
    File.open('.temp.json_config.json', 'w') do |io|
      io.write <<EOF
{
    // This is a comment; unicorns are lovely
    "foo": {
          "cat": ["meow", "purr"],
          "cow": ["moo"],
          "dinosaur": /* Likewise is this weirdly placed comment o; */ ["rawr"],
          "bunny": ["unimaginable cuteness that forces you to coo"] // noxgirl+swarley=<3
           }

}
      
EOF
    end
    @conf.rehash!
    @conf.x.should.equal('foo' => {
                            'cat'      => ['meow', 'purr'],
                            'cow'      => ['moo'],
                            'dinosaur' => ['rawr'],
                            'bunny'    => ['unimaginable cuteness that forces you to coo']
                          }
                        )
  end

  it 'should fail on rehash!() if data is bad' do
    File.open('.temp.json_config.json', 'w') do |io|
      io.write <<EOF
THIS ARE RUBBISH

THAT W!LL F41L

...0R SHOULD
EOF
    end
    @conf.rehash!.should.equal 0
  end

  it 'should should revert to old data if rehash!() fails' do
    @conf.x.should.equal('foo' => {
                            'cat'      => ['meow', 'purr'],
                            'cow'      => ['moo'],
                            'dinosaur' => ['rawr'],
                            'bunny'    => ['unimaginable cuteness that forces you to coo']
                          }
                        )
  end

  after do
    File.delete('.temp.json_config.json')
  end

end
