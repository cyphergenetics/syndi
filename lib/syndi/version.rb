# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (see LICENSE).

module Syndi
  
  # Standard version string.
  #
  # We use semantic versioning: +MAJOR.MINOR.PATCH.PRE.PRENUM+
  VERSION = '0.1.3'.freeze
  
  # Standard version plus the codename (assigned to each minor release).
  #
  # i.e., +VERSION-CODENAME+
  FULLVERSION  = "#{VERSION}-phoenix".freeze

  # @return [Boolean] Whether this is a prerelease copy.
  def self.prerelease?
    (VERSION =~ /alpha|beta|pre/).nil? ? false : true
  end
  
  # @return [Boolean] Whether this is a release candidate copy.
  def self.rc?
    (VERSION =~ /rc/).nil?    ? false : true
  end

  # @return [Boolean] Whether this is an edge (i.e. testing, development, unstable) copy.
  def self.edge?
    prerelease? || rc? || VERSION < '1'
  end

end

# vim: set ts=4 sts=2 sw=2 et:
