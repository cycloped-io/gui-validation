class Dataset < ActiveRecord::Base
  attr_accessor :file
  attr_accessor :user_id

  validates :name, presence: true
  validates :relation, presence: true
  validates :language, presence: true

  has_many :statements
  has_and_belongs_to_many :users

  def next_decision_for(user)
    user.decisions_for(self).where('value is null').order(:position).first
  end
end
