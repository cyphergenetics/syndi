# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (see LICENSE).
require(File.join(File.expand_path(File.dirname(__FILE__)), 'helper.rb'))

require 'auto/api/timers'

describe 'The API timer system' do

  before do
    @clock = Auto::API::Timers.new
  end

  it 'should have a publicly viewable hash of timers' do
    @clock.timers.class.must_equal Hash
  end

  it 'should correctly execute once-only timers' do
    @meow = false
    @clock.spawn(0.01, :once) { @meow = true }
    sleep 0.02
    @meow.must_equal true
  end

  it 'and repeating timers' do
    @moo = 1
    @clock.spawn(0.01, :every) { @moo += 1; self.die if @moo == 3 }
    sleep 0.04
    @moo.must_equal 3
  end

  it 'should terminate a timer with #del' do
    @rawr = true
    timer = @clock.spawn(0.01, :once) { @rawr = false }
    @clock.del timer
    sleep 0.02
    @rawr.must_equal true
  end

end

# vim: set ts=4 sts=2 sw=2 et:
