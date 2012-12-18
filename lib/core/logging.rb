# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

############################################################################
# Core::Logging
#
# A class which provides a comprehensive yet simple and vital logging system
# for the core.
############################################################################

# Entering namespace: Core
module Core

  # Class Logging: Core logging functionality.
  class Logging

    # Create a new instance of Core::Logging.
    # ()
    def initialize

      # Set our status to good.
      @status = :good

      # Create log/ if it's missing.
      unless Dir.exists?('logs/')
        begin
          Dir.mkdir('logs/')
        rescue => e
          @status = :bad
          $m.error("Could not create logs/: #{e}", true, e.backtrace)
          return
        end
      end

    end

    # Log message of type ERROR.
    # (str)
    def error(msg)
      log('ERROR', msg)
    end

    # Log message of type WARNING.
    # (str)
    def warning(msg)
      log('WARNING', msg)
    end

    # Log message of type INFO.
    # (str)
    def info(msg)
      log('INFO', msg)
    end

    # Log message of type DEBUG.
    # (str)
    def debug(msg)
      log('DEBUG', msg)
    end

    #######
    private
    #######

    # Log a message.
    # (str, str)
    def log(type, msg)

      # If our status is bad, ignore the logging request.
      return if @status == :bad
      
      # Create log/ if it's missing.
      unless Dir.exists?('logs/')
        begin
          Dir.mkdir('logs/')
        rescue => e
          @status = :bad
          $m.error("Could not create logs/: #{e}", true, e.backtrace)
          return
        end
      end

      # Open the file in the format of log/YYYYMMDD.log.
      time = Time.now
      File.open("logs/#{time.strftime('%Y%m%d')}.log", 'a') do |io|
        # Append the message.
        io.puts "[#{time.strftime('%Y-%m-%d %H:%M:%S %z')}] [#{type}] #{msg}"
      end

    end # def log

  end # class Logging

end # module Core

# vim: set ts=4 sts=2 sw=2 et:
