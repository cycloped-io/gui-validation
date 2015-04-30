require 'bundler/setup'
require 'sinatra'
require 'csv'
require 'slop'
require 'cycr'
require 'mapping'

input1_path = ENV['INPUT_1_PATH'] || 'data/categories_validated_1.csv'
input2_path = ENV['INPUT_2_PATH'] || 'data/categories_validated_2.csv'
output_path = ENV['OUTPUT_PATH'] || input1_path+'.out'

cyc = Cyc::Client.new(cache: true, host: 'localhost', port: 3601)
name_service = Mapping::Service::CycNameService.new(cyc)


user1 = []
user2 = []

CSV.open(input1_path, "r:utf-8") do |input|
  input.each do |tuple|
    user1 << tuple
  end
end

CSV.open(input2_path, "r:utf-8") do |input|
  input.each do |tuple|
    user2 << tuple
  end
end



selected = []

output = CSV.open(output_path, "a+:utf-8")

user1.each_with_index do |row, index|
  if user2[index][1]!=row[1]
    selected << index
  else
    output << row[1..3]
  end

end

p 'Size:', selected.size

counter=0


get '/' do
  redirect to("/#{counter}")
end

get '/:id' do
  counter = params[:id].to_i
  if counter<selected.size then
    index = selected[counter]
    wiki1, cyc1, cyc_name1 = user1[index]
    wiki2, cyc2, cyc_name2 = user2[index]

    wiki_url = 'http://en.wikipedia.org/wiki/Category:'+wiki1
    cyc_url1 = 'http://sw.opencyc.org/concept/'+cyc1
    cyc_url2 = 'http://sw.opencyc.org/concept/'+cyc2


    erb :index_set_2, :locals => {:wiki_url => wiki_url, :cyc_url1 => cyc_url1, :cyc_url2 => cyc_url2, :wiki => wiki1, :cyc1 => cyc_name1, :cyc2 => cyc_name2,:counter => counter}
  else
    erb :finish
  end
end

post '/:action/:id' do
  if params[:id] =~ /^\d+$/ && %w{u1 u2 set}.include?(params[:action])
    counter = params[:id].to_i
    index = selected[counter]

    wiki= user1[index][0]

    if params[:action] == 'u1'
      wiki, cyc_id, cyc_name = user1[index]
    elsif params[:action] == 'u2'
      wiki, cyc_id, cyc_name = user2[index]
    end

    if params[:action] == 'set'
      cyc_name = params[:cyc_name]
      #p cyc_name
      term = name_service.find_by_term_name(cyc_name)
      p term
      if !term.nil?
        cyc_id = cyc.compact_hl_external_id_string(term)
      else
        cyc_id = ''
      end
    end

    p [wiki,cyc_id,cyc_name]
    output << [wiki,cyc_id,cyc_name]
    output.flush
    counter += 1
    redirect to("/#{counter}")
  else
    erb :invalid
  end
end
