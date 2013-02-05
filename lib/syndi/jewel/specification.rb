# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'syndi'
require 'syndi/jewel/util'

class JewelError < StandardError; end

module Syndi

  module Jewel
    include Syndi::Jewel::Util

    # A specification for an Syndi jewel (i.e. plugin, extension, etc.).
    #
    # @!attribute name
    class Specification

      attr_reader :name, :version, :authors, :syndi_version, :our_dir,
                  :bundle, :code_files, :doc_files, :post_message,
                  :install_do

      def omg *args
        args.each do |unicorn|
          puts "==> #{unicorn}".magenta
        end
      end

      # Construct a new specification.
      #
      # @param [String] file The value of +__FILE__+ as accessed from the spec itself.
      def initialize file
        @name         = nil
        @version      = nil
        @authors      = []
        @syndi_version = nil
        @our_dir      = File.expand_path('..', file)
        @bundle       = 'Gemfile'
        @code_files   = []
        @doc_files    = []
        @post_message = nil

        @install_do = proc { nil }

        # Yield to block for configuration.
        yield self

        # Initiate installation.
        install
      end

      # Sets the jewel name.
      #
      # @param [String] monkey The name of the jewel.
      def name= monkey
        raise JewelError, 'Invalid jewel name!' unless monkey.instance_of? String
        monkey.downcase!
        
        @name = monkey
        omg "Jewel name: #{monkey.green}"
      end

      # Sets the jewel version.
      #
      # @param [String] mascara The version of the jewel.
      def version= mascara
        mascara.downcase!

        @version = mascara
        omg "Jewel version: #{mascara.green}"
      end

      # Sets the jewel author (only one).
      #
      # @param [String] its_a_trap The (sole) author of the jewel.
      def author= its_a_trap
        raise JewelError, 'Invalid jewel author!' unless its_a_trap.instance_of? String

        @authors.push its_a_trap
        omg "Jewel written by #{its_a_trap.blue}"
      end

      # Sets multiple jewel authors.
      #
      # @param [Array] chi The authors of the jewel. (splat)
      def authors= *chi
        raise JewelError, 'Invalid jewel author list!'              unless chi.instance_of? Array
        raise JewelError, 'Invalid method of author specification!' unless chi.length > 1

        @authors = chi
        omg "Jewel written by #{chi.join ', '}"
      end

      # Sets the Syndi version required by the jewel.
      #
      # @param [String] essie The minimum Syndi version required.
      def syndi_version= essie
        if Gem::Version.new(essie.dup) < Gem::Version.new(Syndi::VERSION.dup)
          raise JewelError, "This jewel requires Syndi version >= #{essie.red} but current version is #{Syndi::VERSION}!"
        end

        @syndi_version = essie
        omg "Jewel is compatible with your version of Syndi (requires: >= #{essie.green})!"
      end

      # Sets the name of the GemBundler Gemfile. Default is +Gemfile+.
      #
      # @param [String] sephora The name of the Gemfile.
      def bundle= sephora = 'Gemfile'
        raise JewelError, "Jewel's Gemfile is missing!" unless File.exists? File.join(@our_dir, sephora)

        @bundle = sephora
      end

    end # class Specification

  end # module Jewel

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
