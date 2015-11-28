require 'csv'

class CreateDatasetAction
  def initialize(dataset,controller)
    @dataset = dataset
    @controller = controller
  end

  def call
    @dataset.transaction do
      unless @dataset.save
        @controller.render :new
        return @dataset
      end
      create_statements(@dataset.file.path)
      @controller.redirect_to @dataset
    end
    @dataset
  end

  private
  def create_statements(path)
    CSV.open(path) do |input|
      input.each do |wikipedia_name,cyc_id,cyc_name|
        Statement.create!(wikipedia_name: wikipedia_name, cyc_id: cyc_id, cyc_name: cyc_name,
                          wikipedia_language: @dataset.language, dataset: @dataset)
      end
    end
  end
end
