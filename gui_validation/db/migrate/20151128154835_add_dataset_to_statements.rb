class AddDatasetToStatements < ActiveRecord::Migration
  def change
    add_reference :statements, :dataset, index: true, foreign_key: true
  end
end
