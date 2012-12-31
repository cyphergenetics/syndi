# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

require 'bacon'
require 'spec/test_helpers'

require 'auto/api/timers'

describe 'The API timer system' do

  before do
    @clock = Auto::API::Timers.new
  end

  it 'should have a publicly viewable hash of timers' do
    @clock.timers.class.should.equal Hash
  end

  it 'should correctly execute once-only timers' do
    @meow = false
    @clock.spawn(3, :once) { @meow = true }
    sleep 4
    @meow.should.be.true
  end

  it 'and repeating timers' do
    @moo = 1
    @clock.spawn(2, :every) { @moo += 1; self.die if @moo == 3 }
    sleep 5
    @moo.should.equal 3
  end

  it 'should terminate a timer with #del' do
    @rawr = true
    timer = @clock.spawn(3, :once) { @rawr = false }
    @clock.del timer
    sleep 4
    @rawr.should.be.true
  end

end

# vim: set ts=4 sts=2 sw=2 et:
