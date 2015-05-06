require 'bundler/setup'
require 'sinatra'
require 'csv'
require 'slop'
require 'cycr'
require 'mapping'

input_path = ENV['INPUT_PATH'] || 'data/patterns/with_examples_and_maping.csv'
output_path = ENV['OUTPUT_PATH'] || input_path+'.out'

cyc = Cyc::Client.new(cache: true, host: 'localhost', port: 3601)
name_service = Mapping::Service::CycNameService.new(cyc)

selected = []

CSV.open(input_path, "r:utf-8") do |input|
  input.each do |tuple|
    selected << tuple
  end
end


counter=0
if File.exist?(output_path)
  CSV.open(output_path, "a+:utf-8") do |output|
    counter = output.read.size
  end
end

output = CSV.open(output_path, "a+:utf-8")


get '/' do
  redirect to("/#{counter}")
end

get '/:id' do
  counter = params[:id].to_i
  if counter<selected.size then
    pattern, cyc_id, cyc_name, support, *categories = selected[counter]
    #wiki_url = 'http://en.wikipedia.org/wiki/'+wiki
    #cyc_url = 'http://sw.opencyc.org/concept/'+cyc

    if !cyc_name.nil?
      cyc_url = 'http://sw.opencyc.org/concept/'+cyc_id
    else
      cyc_url = 'http://sw.opencyc.org/'
    end

    erb :patterns, :locals => {:pattern => pattern, :support => support.to_i, :cyc_url => cyc_url, :cyc => cyc_name, :categories => categories, :counter => counter}
  else
    erb :finish
  end
end

post '/:action/:id' do
  if params[:id] =~ /^\d+$/ && %w{v set}.include?(params[:action])
    counter = params[:id].to_i
    pattern, cyc_id, cyc_name, support, *categories = selected[counter]

    if params[:action] == 'set'
      cyc_name = params[:cyc_name]
      p cyc_name
      term = name_service.find_by_term_name(cyc_name)
      p term
      if !term.nil?
        cyc_id = cyc.compact_hl_external_id_string(term)
      else
        cyc_id = ''
      end
    end


    output << [pattern, cyc_id, cyc_name]
    output.flush
    counter += 1
    redirect to("/#{counter}")
  else
    erb :invalid
  end
end
