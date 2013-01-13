#!/usr/bin/env ruby
# Copyright (c) 2013, Autumn Perrault, et al. All rights reserved.
# This free software is distributed under the FreeBSD license (LICENSE.md).

# yaml_json.rb
#
# Because Auto 4 supports both YAML and JSON, this script has been provided for
# the purpose of converting configuration files between the two types. It may
# prove useful.
#
# It's easy to use. Use `ruby yaml_json.rb config.file out.file`. It will 
# determine the type on the basis of the extension of the first file, and 
# convert to the opposite type, writing the result to the second file.
#
# @author noxgirl

require 'psych'
require 'json'

# Process YAML
#
# @param [String] data The data to process.
#
# @return [Hash{}] The configuration data in a Hash.
def process_yaml(data)

  y = YAML.parse(data)
  y.to_ruby

end

# Process JSON
#
# @param [String] data The data to process.
#
# @return [Hash{}] The configuration data in a Hash.
def process_json(data)

  data.gsub!(/(#[^"\n\r]*(?:"[^"\n\r]*"[^"\n\r]*)*[\r\n]|\/\*([^*]|\*(?!\/))*?\*\/)(?=[^"]*(?:"[^"]*"[^"]*)*$)/, '')
  JSON.parse(data)

end

# Produce YAML
#
# @param [Hash{}] conf The configuration Hash.
# @param [IO] out IO object to which to write.
def to_yaml(conf, out)
  YAML.dump(conf, out)
end

# Produce JSON
#
# @param [Hash{}] conf The configuration Hash.
# @param [IO] out IO object to which to write.
def to_json(conf, out)
  out.write JSON.pretty_generate(conf)
end

if ARGV.length < 2
  puts <<END
Too few arguments.
Usage: #$0 config.file out.file
END
  exit
elsif ARGV.length > 2
  puts <<END
Too many arguments.
Usage: #$0 config.file out.file
END
  exit
end

filename = ARGV[0]
output = ARGV[1]

unless File.exists? filename
  puts "File doesn't exist: #{filename}"
  exit
end

input = File.read(filename)

ft_in, ft_out  = case File.extname(filename)
                 when '.yml' then ["json", "yaml"]
                 when '.json' then ["yaml", "json"]
                 else
                   # Unknown file type.
                   puts "Unknown file type for #{filename}"
                   exit
                 end

# This effectively calls to_#{filetype}
File.open(output, 'w') {|o| send("to_" << ft_in, send("process_" << ft_out, input), o) }

puts "Converted #{filename} to #{ft_in.upcase} and wrote to #{output}."
