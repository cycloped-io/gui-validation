class AddRelationToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :relation, :string
  end
end
