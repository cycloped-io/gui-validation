#!/usr/bin/env ruby

require 'bundler/setup'
require 'slop'
require 'csv'
require 'progress'


options = Slop.new do
  banner "#{$PROGRAM_NAME} -f validation.csv -t high_level.csv -o new_validation.csv\n" +
    "Select validations that was marked as invalid or was assinged Thing"

  on :f=, :input, "File with validated articles", required: true
  on :o=, :output, "Output file with articles to validate", required: true
end

begin
  options.parse
rescue => ex
  puts ex
  puts options
  exit
end


CSV.open(options[:input],"r:utf-8") do |input|
  CSV.open(options[:output],"w") do |output|
    input.with_progress do |decision,article,id,name|
      next if decision == "v" && name!="Thing"
      output << [article,id,name]
    end
  end
end
