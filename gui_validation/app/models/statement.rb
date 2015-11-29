class Statement < ActiveRecord::Base
  validates :cyc_id, presence: true
  validates :cyc_name, presence: true
  validates :wikipedia_name, presence: true
  validates :wikipedia_language, presence: true

  belongs_to :dataset
  has_many :decisions

  LANGUAGE_MAPPING = {
    "English" => "en",
    "Polish" => "pl",
    "Japanese" => "ja",
    "Italian" => "it"
  }

  def wiki_link
    "http://#{language_namespace(self.language)}.wikipedia.org/wiki/#{self.wikipedia_name}"
  end

  def cyc_link
    "http://sw.opencyc.org/concept/#{self.cyc_id}"
  end

  def self.languages
    LANGUAGE_MAPPING.keys
  end

  def language
    self.dataset.language
  end

  private
  def language_namespace(language)
    LANGUAGE_MAPPING[language]
  end
end
