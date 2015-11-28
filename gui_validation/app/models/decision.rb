class Decision < ActiveRecord::Base
  validates :user_id, presence: true
  validates :statement_id, presence: true
  validates :dataset_id, presence: true
  validates :position, presence: true, numericality: {min: 0}


  belongs_to :user
  belongs_to :statement
  belongs_to :dataset

  def wiki_link
    self.statement.wiki_link
  end

  def cyc_link
    self.statement.cyc_link
  end

  def cyc_name
    self.statement.cyc_name
  end

  def wikipedia_name
    self.statement.wikipedia_name
  end
end
