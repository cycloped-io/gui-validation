class Decision < ActiveRecord::Base
  validates :user_id, presence: true
  validates :statement_id, presence: true
  validates :dataset_id, presence: true
  validates :position, presence: true, numericality: {min: 0}
  validates :value, inclusion: {allow_blank: true, in: %w{positive unsure negative}}

  delegate :wiki_link, :cyc_link, :wikipedia_name, :cyc_name, :cyc_id, to: :statement
  delegate :name, :progress, to: :dataset
  delegate :title, :comment, :super_types, to: :cyc_description, prefix: :cyc

  belongs_to :user
  belongs_to :statement
  belongs_to :dataset

  def progress
    self.user.progress(self.dataset)
  end

  def progress_nominator
    self.user.progress_nominator(self.dataset)
  end

  def progress_denominator
    self.user.progress_denominator(self.dataset)
  end

  def last_position
    self.dataset.decisions.where(user_id: self.user_id).order(:position).select(:position).last.position
  end

  def next
    next_decision = Decision.where(user_id: self.user_id).where(dataset_id: self.dataset_id).
      where('position > ?',self.position).order(:position).first
    next_decision || self
  end

  def previous
    previous_decision = Decision.where(user_id: self.user_id).where(dataset_id: self.dataset_id).
      where('position < ?',self.position).order(:position).last
    previous_decision || self
  end

  def cyc_description
    @cyc_description ||= ConceptDescription.new(self.cyc_id,self.cyc_link,self.logger)
  end
end
