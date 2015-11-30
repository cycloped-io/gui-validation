require 'open-uri'

class ConceptDescription
  def initialize(id,link,logger)
    @id = id
    @xml = Nokogiri.XML(open(link))
    @logger = logger
  end

  def title
    @xml.xpath("//owl:Class[@rdf:about='#{@id}']/rdfs:label").first.text
  rescue
    "Title is missing!"
  end

  def comment
    @xml.xpath("//owl:Class[@rdf:about='#{@id}']/rdfs:comment").first.text
  rescue
    "Comment is missing!"
  end

  def super_types
    nodes = @xml.xpath("//owl:Class[@rdf:about='#{@id}']/rdfs:subClassOf")
    nodes.map{|e| e.attributes["resource"].to_s }.map do |id|
      [
        (@xml.xpath("//owl:Class[@rdf:about='#{id}']/rdfs:label").first.text rescue nil),
        (@xml.xpath("//owl:Class[@rdf:about='#{id}']/rdfs:comment").first.text rescue "")
      ]
    end.reject{|l,c| l.nil? }
  rescue => ex
    @logger.error ex
    @logger.error ex.backtrace[0..10].join("\n")
    []
  end


end
