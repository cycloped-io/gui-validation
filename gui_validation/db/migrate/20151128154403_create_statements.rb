class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.string :cyc_name
      t.string :cyc_id
      t.string :wikipedia_name
      t.string :wikipedia_language
      t.string :relation

      t.timestamps null: false
    end
  end
end
