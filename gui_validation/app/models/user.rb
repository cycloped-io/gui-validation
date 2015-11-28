class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :datasets
  has_many :decisions

  def progress(dataset)
     (decisions_for(dataset).where('value is not null').count / dataset.statements.count.to_f * 100).round(1)
  end

  def decisions_for(dataset)
    self.decisions.where(dataset_id: dataset.id)
  end
end
