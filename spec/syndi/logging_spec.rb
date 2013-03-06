# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi/logging'

class FakeLogging
  def method_missing meth, *_args, &_block
    $LoggingMethod = meth
  end
end

describe Syndi::Logging do
  include Syndi::Logging

  before do
    Cindy = ::Syndi
    module ::Syndi
      extend self
      def log
        FakeLogging.new
      end
    end
  end

  describe '#info' do
    it 'calls Syndi.log.info()' do
      info "Kittens are cute and fluffy."
      expect($LoggingMethod).to eq :info
    end
  end

  after do
    Object.send :remove_const, :Syndi
    ::Syndi = Cindy
  end

end

# vim: set ts=4 sts=2 sw=2 et:
