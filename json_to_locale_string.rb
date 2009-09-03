#!/usr/bin/env ruby
require 'yaml'
yaml_file   = ARGV[0]
result_file = ARGV[1]

f = File.new(result_file,'w')
f.write '__LocaleString = '
f.write YAML.load_file(yaml_file).inspect.gsub(/\"=>\"/,'" : "')
f.close
