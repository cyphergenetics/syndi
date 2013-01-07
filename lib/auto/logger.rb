# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the FreeBSD license (LICENSE.md).
require 'auto/exceptions'

# Entering namespace: Auto
module Auto

  # The central Auto logging class, which is essential to operation.
  #
  # @api Auto
  # @since 4.0.0
  # @author noxgirl
  #
  # @!attribute [r] status
  #   @return [Symbol] +:good+ or +:bad+.
  #
  #
  # @!method error(message)
  #   @param [String] message The error message.
  #
  # @!method warning(message)
  #   @param [String] message The warning message.
  #
  # @!method info(message)
  #   @param [String] message The informative message.
  #
  # @!method debug(message)
  #   @param [String] message The debug message.
  class Logger

    attr_reader :status

    # Construct a new logger.
    #
    # @raise LogError If logs/ neither exists nor can be created.
    def initialize

      # Set our status to good.
      @status = :good
      log_directory_check

    end

    # Methods for logging, ERROR, WARNING, INFO, and DEBUG.
    # No reason to use symbols here since the array is only generated
    # as often as this class is reloaded.
    %w[error warning info debug].each do |meth|
      define_method(meth) {|msg| log(meth.uc, msg) }
    end

    #######
    private
    #######

    # Log a message.
    #
    # @param [String] type The type of message: ERROR, WARNING, INFO, DEBUG.
    # @param [String] msg The message.
    #
    # @raise [LogError] If logs/neither exists nor can be created.
    #
    # @return [0] If the status is +:bad+.
    def log(type, msg)

      # If our status is bad, ignore the logging request.
      return 0 if @status == :bad
      
      # Create logs/ if it's missing.
      log_directory_check

      # Open the file in the format of log/YYYYMMDD.log.
      time = Time.now
      File.open("logs/#{time.strftime('%Y%m%d')}.log", 'a') do |io|
        # Append the message.
        io.puts "[#{time.strftime('%Y-%m-%d %H:%M:%S %z')}] [#{type}] #{msg}"
      end

    end # def log

    # Check for the existence of logs/, and create the directory if it does not
    # exist.
    def log_directory_check
      unless Dir.exists?('logs')
        begin
          Dir.mkdir('logs')
        rescue => e
          @status = :bad
          raise LogError, "Could not create logs/: #{e}", e.backtrace
        end
      end
    end

  end # class Logger

end # module Auto

# vim: set ts=4 sts=2 sw=2 et:
