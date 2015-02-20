require 'sinatra'
require 'csv'
require 'slop'

input_path = 'data/fs.csv'


selected = []

CSV.open(input_path, "r:utf-8") do |input|
  input.each do |tuple|
    selected << tuple
  end
end

output = CSV.open(input_path+Time.now.strftime(" %d.%m.%Y %H:%M.csv"), "w:utf-8")
counter = 0

selected.each do |row|
  if row.size > 3
    output << row
    output.flush
    counter+=1
  else
    break
  end
end

get '/' do
  if counter<selected.size then
    wiki, cyc, cyc_name = selected[counter]
    wiki_url = 'http://en.wikipedia.org/wiki/'+wiki
    cyc_url = 'http://sw.opencyc.org/concept/'+cyc
    erb :index, :locals => {:wiki_url => wiki_url, :cyc_url => cyc_url, :wiki => wiki, :cyc => cyc_name}
  else
    erb :finish
  end
end

get '/:action' do
  output << [params[:action]]+selected[counter]
  output.flush
  counter += 1
  redirect to('/')
end