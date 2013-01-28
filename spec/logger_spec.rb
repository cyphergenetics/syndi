# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (see LICENSE).
require(File.expand_path('../helper.rb', __FILE__))

require 'libauto'

describe Auto::Logger do

  before do
    Dir.chdir(File.expand_path('..', __FILE__))
  end

  describe "#new" do

    it 'should produce directory logs/' do
      logger = Auto::Logger.new
      Dir.exists?("logs").must_equal true
    end

  end

  after do
    Dir[File.join('logs', '*')].each { |f| File.delete f }
    Dir.rmdir("logs")
  end

end

# vim: set ts=4 sts=2 sw=2 et:
