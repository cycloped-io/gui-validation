class SplitDatasetAction
  def initialize(dataset,partials,controller)
    @dataset = dataset
    @partials = partials
    @controller = controller
  end

  def call
    @dataset.transaction do
      return if @partials <= 0
      partial_size = @dataset.statements.count / @partials
      @partials += 1 if partial_size * @partials != @dataset.statements.count
      @partials.times do |index|
        new_dataset = Dataset.create!(name: partial_name(index), relation: @dataset.relation, language: @dataset.language)
        # NO offset! - the decisions are removed from the dataset, so there is no need for offset.
        @dataset.statements.limit(partial_size).each do |statement|
          statement.update_attribute(:dataset,new_dataset)
          statement.decisions.each do |decision|
            decision.update_attribute(:dataset,new_dataset)
          end
        end
        @dataset.users.each do |user|
          new_dataset.users << user
        end
      end
    end
  end

  private
  def partial_name(index)
    "#{@dataset.name} - #{index + 1} / #{@partials}"
  end
end
