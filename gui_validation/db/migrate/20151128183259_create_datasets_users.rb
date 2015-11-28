class CreateDatasetsUsers < ActiveRecord::Migration
  def change
    create_table :datasets_users, id: false do |t|
      t.references :dataset, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
    add_index :datasets_users, [:dataset_id,:user_id], unique: true
  end
end
