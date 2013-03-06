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
require 'celluloid/io'
    
require 'syndi'

$temp_dir = Dir.mktmpdir
Syndi.dir = $temp_dir
$VERBOSITY = -1
Syndi.celluloid_log

class TestServer
  include Celluloid::IO
  attr_accessor :server

  def initialize address, port
    puts "*** Experimental TCP server starting on #{address}:#{port}"
    @server = TCPServer.new address, port
    @buffer = ''
    async.run
  end

  def run
    loop { async.handle_conn @server.accept }
  end

  def handle_conn client
    _, port, addr = client.peeraddr
    puts "*** Experimental connection from #{addr}:#{port}"
    loop { @buffer << client.readpartial(4096) }
  rescue EOFError
    puts "*** Connection with #{addr}:#{port} lost"
    client.close
  end

  def finalize
    puts '*** Server terminating'
    @server.close if @server
  end

  def buffer
    value = @buffer
    @buffer = ''
    value
  end
end


module Helper

  def with_tcp_serv
    server = TestServer.new '127.0.0.1', 7884
    yield '127.0.0.1', 7884, server
    server.terminate
  end

end

RSpec.configure do |conf|
  conf.include Helper

  conf.after(:all) do
    Dir.chdir __dir__
    FileUtils.remove_entry $temp_dir if Dir.exists? $temp_dir
    Syndi.dir = __dir__
  end

  conf.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# vim: set ts=4 sts=2 sw=2 et:
