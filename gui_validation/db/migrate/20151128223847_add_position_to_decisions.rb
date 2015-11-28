class AddPositionToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :position, :integer
  end
end
