# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).

require 'spec/auto/api'

module Spec
  module Auto
    class Bot
      attr_reader :events
      def initialize
        [:debug,:warn,:error,:log,:info,:foreground].each do |x| 
          define_singleton_method(x) {|*args| nil }
        end
        @events = Spec::Auto::API::Events.new
      end
    end
  end
end

# vim: set ts=4 sts=2 sw=2 et:
