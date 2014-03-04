class AddZoneIdToRecords < ActiveRecord::Migration
  def up
    add_column :records, :zonename_id, :integer
  end

  def down
    remove_column :records, :zonename_id
  end
end
