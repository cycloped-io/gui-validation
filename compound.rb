require 'sinatra'
require 'csv'
require 'slop'

input_path = ENV['INPUT_PATH'] || 'data/patterns/patterns.csv'
output_path = ENV['OUTPUT_PATH'] || input_path+'.out'


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
    pattern, support, *categories = selected[counter]
    #wiki_url = 'http://en.wikipedia.org/wiki/'+wiki
    #cyc_url = 'http://sw.opencyc.org/concept/'+cyc
    erb :compound, :locals => {:pattern => pattern, :support => support.to_i, :categories => categories, :counter => counter}
  else
    erb :finish
  end
end

post '/:action/:id' do
  if params[:id] =~ /^\d+$/ && %w{v i u}.include?(params[:action])
    counter = params[:id].to_i
    output << [params[:action]]+selected[counter]
    output.flush
    counter += 1
    redirect to("/#{counter}")
  else
    erb :invalid
  end
end
