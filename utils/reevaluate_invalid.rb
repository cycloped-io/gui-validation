#!/usr/bin/env ruby

require 'bundler/setup'
require 'slop'
require 'csv'
require 'progress'


options = Slop.new do
  banner "#{$PROGRAM_NAME} -f validation.csv -t high_level.csv -o new_validation.csv\n" +
    "Select validations that was marked as invalid and assign high-level concepts"

  on :f=, :input, "File with validated articles", required: true
  on :o=, :output, "Output file with articles to validate", required: true
  on :t=, :types, "High-level assignments of types", required: true
end

begin
  options.parse
rescue => ex
  puts ex
  puts options
  exit
end

high_level = {}
CSV.open(options[:types],"r:utf-8") do |input|
  input.with_progress do |article,*types|
    high_level[article] = types.each_slice(2).map.to_a.sample
  end
end

CSV.open(options[:input],"r:utf-8") do |input|
  CSV.open(options[:output],"w") do |output|
    input.with_progress do |decision,article,id,name|
      next unless decision == "i"
      type = high_level[article]
      if type.nil?
        puts "Missing high-level type for #{article}!"
        next
      end
      output << [article,*type]
    end
  end
end
