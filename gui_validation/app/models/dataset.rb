class Dataset < ActiveRecord::Base
  attr_accessor :file
  attr_accessor :user_id
  attr_accessor :partials

  validates :name, presence: true
  validates :relation, presence: true
  validates :language, presence: true

  has_many :statements, dependent: :destroy
  has_many :decisions, dependent: :destroy
  has_and_belongs_to_many :users, dependent: :destroy

  def next_decision_for(user)
    last_decision = user.decisions_for(self).where('value is not null').order(:updated_at).last
    remaining_decisions = user.decisions_for(self).where('value is null').order(:position)
    if last_decision
      next_decision = remaining_decisions.where('position > ?',last_decision.position).first
      return next_decision if next_decision
    end
    remaining_decisions.first
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
