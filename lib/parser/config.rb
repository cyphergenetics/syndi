# Auto 4
# Copyright (c) 2013, Auto Project
# Distributed under the terms of the three-clause BSD license.

# Entering namespace: Parser
module Parser

  # Class Config: Configuration parser.
  class Config

    attr_reader :path, :conf

    # Create a new instance of Parser::Config.
    # (str)
    def initialize(path)
      
      # First, check if the file exists.
      unless File.exists?(path)
        $m.error("No such file `#{path}`, cannot load configuration!", true)
      end
      @path = path

      # Prepare to parse.
      @conf = {}

      # Parse it.
      @conf = parse or $m.error("Failed to parse configuration file!", true)

    end
    
    # TODO: Rehash the configuration file.
    # ()
    def rehash
    end

    # Get a configuration value.
    # (str, [str])
    def get(section, name=nil)
      if /:/ =~ section
        ssec, sname = section.split(':', 2)

        return unless @conf.has_key? ssec
        return unless @conf[ssec].has_key? sname
        if !name.nil?
          return unless @conf[ssec][sname].has_key? name
          @conf[ssec][sname][name]
        else @conf[ssec][sname]
        end
      else
        return unless @conf.has_key? section
        if !name.nil?
          return unless @conf[section].has_key? name
          @conf[section][name]
        else @conf[section]
        end
      end
    end

    #######
    private
    #######

    # Parse the configuration file.
    def parse
      
      # Open the file for reading.
      begin
        io = File.open(@path)
      rescue => e
        $m.error("Could not open `#@path`: #{e}", false, e.backtrace)
        return
      end

      # Iterate over it.
      conf = { '*' => {} }
      sec = '*'
      io.each_with_index do |line, no|
        line.strip!
        no += 1

        # Ignore comments.
        next if line[0] == ';'
        # Stop at EOF.
        break if line == 'EOF'

        # Match beginning of block: BLOCK "NAME" {
        if re = /^(.+) "(.*)" {$/.match(line)
          # Blocks inside blocks are not yet supported.
          if sec != '*'
            $m.error("Error in config (line #{no}): Already inside block.")
            return
          end

          re.pop if re[2] == ''

          # Check for invalid characters.
          if /[^A-Za-z0-9_-]/ =~ re[1]
            $m.error("Error in config (line #{no}): Invalid characters in `#{re[1]}`")
            return
          end

          if re.length == 3
            sec = "#{re[1]} #{re[2]}"
            
            if !conf.has_key? re[1]
              conf[re[1]] = {}
            end

            if !conf[re[1]].has_key? re[2]
              conf[re[1]][re[2]] = {}
            end
          elsif re.length == 2
            sec = re[1]
            
            if !conf.has_key? re[1]
              conf[re[1]] = {}
            end
          end
        
        # Match ending of block: }
        elsif /^}$/.match(line)
          # Stray closing curly bracket.
          if sec == '*'
            $m.error("Error in config (line #{no}): Stray closing curly bracket.")
            return
          end

          sec = '*'

        # Match value: NAME VALUE
        elsif re = /([\w_-]+) (.+)/.match(line)
          val = nil

          # Is the value an integer?
          if /[^0-9]/ !~ re[2]
            val = re[2].to_i
          # Is the value a yes?
          elsif /^yes$/ =~ re[2]
            val = true
          # Is the value a no?
          elsif /^no$/ =~ re[2]
            val = false
          # Is the value a string?
          elsif /^"(.*)"$/ =~ re[2]
            val = $1
          else
            # Unrecognised value type.
            $m.error("Error in config (line #{no}): Unrecognised value type.")
            return
          end

          # What kind of block are we dealing with?
          if / / =~ sec
            ssec, sname = sec.split(' ', 2)
            # Check if this value already exists.
            if conf[ssec][sname].has_key? re[1]
              conf[ssec][sname][re[1]] << val
            else
              # Nope, create it.
              conf[ssec][sname][re[1]] = [val]
            end
          else
            # Check if this value already exists.
            if conf[sec].has_key? re[1]
              conf[sec][re[1]] << val
            else
              # Nope, create it.
              conf[sec][re[1]] = [val]
            end
          end # block check

        end # match

      end # file iteration

      # Close the file.
      io.close


      conf
    end # def parse

  end # class Config

end # module Parser

# vim: set ts=4 sts=2 sw=2 et:
