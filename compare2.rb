require 'sinatra'
require 'csv'
require 'slop'

input1_path = ENV['INPUT_1_PATH'] || 'data/cc_validated_1.csv'
input2_path = ENV['INPUT_2_PATH'] || 'data/cc_validated_2.csv'
output_path = ENV['OUTPUT_PATH'] || input1_path+'.out'


user1 = {}
user2 = {}

CSV.open(input1_path, "r:utf-8") do |input|
  input.each do |tuple|
    user1[tuple[1..3]] = tuple[0]
  end
end

CSV.open(input2_path, "r:utf-8") do |input|
  input.each do |tuple|
    user2[tuple[1..3]] = tuple[0]
  end
end

selected = []

user1.keys.each do |key|
  if user1[key]!=user2[key] || user1[key]=='u'
    selected << key
  end
end

p 'Size:', selected.size

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
    wiki, cyc, cyc_name = selected[counter]
    wiki_url = 'http://en.wikipedia.org/wiki/'+wiki
    cyc_url = 'http://sw.opencyc.org/concept/'+cyc
    erb :compare2, :locals => {:wiki_url => wiki_url, :cyc_url => cyc_url, :wiki => wiki, :cyc => cyc_name, :counter => counter, :user1 => user1[selected[counter]], :user2 => user2[selected[counter]]}
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
