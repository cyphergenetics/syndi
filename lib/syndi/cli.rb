# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

require 'thor'

require 'syndi/config/generator'

module Syndi

  # The central command-line interface class which underlies synditool.
  class CLI

    desc 'genconf', 'Start the interactive configuration generator.'
    def confgen
      Syndi::Config::Generator.start
    end

  end # class CLI

end # module Syndi

# vim: set ts=4 sts=2 sw=2 et:
