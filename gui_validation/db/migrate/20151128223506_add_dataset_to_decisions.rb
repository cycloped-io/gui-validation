class AddDatasetToDecisions < ActiveRecord::Migration
  def change
    add_reference :decisions, :dataset, index: true, foreign_key: true
  end
end
