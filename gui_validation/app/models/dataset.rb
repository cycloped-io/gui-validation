class Dataset < ActiveRecord::Base
  attr_accessor :file
  attr_accessor :user_id

  validates :name, presence: true
  validates :relation, presence: true
  validates :language, presence: true

  has_many :statements, dependent: :destroy
  has_many :decisions, dependent: :destroy
  has_and_belongs_to_many :users, dependent: :destroy

  def next_decision_for(user)
    user.decisions_for(self).where('value is null').order(:position).first
  end

  def progress
    if self.users.count > 0
      values = self.users.map{|u| u.progress(self) }
      (values.inject(:+) / values.size).round(1)
    else
      0.0.round(1)
    end
  end
end
