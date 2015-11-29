class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :datasets
  has_many :decisions

  def progress(dataset)
     (progress_nominator(dataset) / progress_denominator(dataset) * 100).round(1)
  end

  def accuracy(dataset)
    positive = decisions_for(dataset).where(value: 'positive').count.to_f
    negative = decisions_for(dataset).where(value: 'negative').count.to_f
    if positive + negative > 0
      (positive / (positive + negative) * 100).round(1)
    else
      0.0.round(1)
    end
  end

  def progress_nominator(dataset)
    decisions_for(dataset).where('value is not null').count
  end

  def progress_denominator(dataset)
    dataset.statements.count.to_f
  end

  def decisions_for(dataset)
    self.decisions.where(dataset_id: dataset.id)
  end
end
