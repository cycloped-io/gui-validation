require 'bundler/setup'
require 'sinatra'
require 'csv'
require 'slop'
require 'cycr'
require 'mapping'

input1_path = ENV['INPUT_1_PATH'] || 'data/cc_validated_1.csv'
input2_path = ENV['INPUT_2_PATH'] || 'data/cc_validated_2.csv'
output_path = ENV['OUTPUT_PATH'] || input1_path+'.out'
types_path = ENV['TYPES_PATH']

def convert_array_to_cyc(array)
  -> { "'(" + array.map { |e| e.to_cyc(true) }.join(" ") + ')' }
end

cyc = Cyc::Client.new(cache: true, host: 'localhost', port: 3601)
name_service = Mapping::Service::CycNameService.new(cyc)

types = []
CSV.open(types_path) do |input|
  input.each do |row|
    types << name_service.find_by_term_name(row.first)
    if types.last.nil?
      puts row.first
    end
  end
end

types = convert_array_to_cyc(types.compact)

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
  if row[0]=='i' || user2[index][2]!=row[3]
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
    valid1, wiki1, cyc1, cyc_name1 = user1[index]
    wiki2, cyc2, cyc_name2 = user2[index]
    wiki_url = 'http://en.wikipedia.org/wiki/'+wiki1
    cyc_url = 'http://sw.opencyc.org/concept/'+cyc1

    term = name_service.find_by_term_name(cyc_name2)
    mid_cyc_id=nil
    mid_cyc_name=nil
    if !term.nil?

      parents = cyc.with_any_mt { |c| c.all_genls_among(term, types) }
      #tuple = []

      cyc.with_any_mt { |c| c.min_cols(convert_array_to_cyc(parents)) }.each do |term|
        id = cyc.compact_hl_external_id_string(term)
        #tuple << id << term
        mid_cyc_name = term.to_s
        mid_cyc_id = id
        break
      end
    end

    erb :compare_mid_level, :locals => {:wiki_url => wiki_url, :cyc_url => cyc_url, :wiki => wiki1, :cyc => cyc_name1, :counter => counter, :user1 => valid1, :user2 => cyc_name2, :mid_cyc_id => mid_cyc_id.to_s, :mid_cyc_name => mid_cyc_name}
  else
    erb :finish
  end
end

post '/:action/:id' do
  if params[:id] =~ /^\d+$/ && %w{v i u set}.include?(params[:action])
    counter = params[:id].to_i
    index = selected[counter]

    p params[:action], params[:cyc_name]
    if params[:action] == 'set'
      p 'ustawoiam'
      user2[index][2] = params[:cyc_name]
    end

    cyc_name = user2[index][2]
    term = name_service.find_by_term_name(cyc_name)
    if !term.nil?
      user2[index][1] = cyc.compact_hl_external_id_string(term)
    end

    if %w{v set}.include?(params[:action])
      output << user2[index]
    else
      output << [user2[index][0]]
    end
    #output << [params[:action]]+selected[counter]
    #output.flush
    counter += 1
    redirect to("/#{counter}")
  else
    erb :invalid
  end
end
