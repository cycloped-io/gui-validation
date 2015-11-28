class AddLanguageToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :language, :string
  end
end
