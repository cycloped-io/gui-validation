#!/usr/bin/env ruby

require 'bundler/setup'
require 'slop'
require 'csv'
require 'progress'


options = Slop.new do
  banner "#{$PROGRAM_NAME} -f validation.csv -t high_level.csv -o new_validation.csv\n" +
             "Some stats about multi high-level types"

  on :f=, :input, "File with high-level assignments of types", required: true
  on :o=, :output, "Output file with multi high-level types", required: true
  # on :t=, :types, "High-level assignments of types", required: true
end

begin
  options.parse
rescue => ex
  puts ex
  puts options
  exit
end

multi = Hash.new { |h, k| h[k]=[] }
CSV.open(options[:input], 'r:utf-8') do |input|
  input.with_progress do |article, *types|
    cyc_names = types.each_slice(2).map.to_a
    if cyc_names.size > 1
      multi[types] << article
    end
  end
end

CSV.open(options[:output], 'w:utf-8') do |output|
  multi.each do |pairs, articles|
    output << pairs
    p pairs, articles
    puts
  end
end
