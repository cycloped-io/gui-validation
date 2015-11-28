class AddIndexToDecisions < ActiveRecord::Migration
  def change
    add_index :decisions, [:user_id, :statement_id], unique: true
  end
end
