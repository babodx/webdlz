class AddZoneIdToXfr < ActiveRecord::Migration
  def up
    add_column :xfr_table, :zonename_id, :integer
  end

  def down
    remove_column :xfr_table, :zonename_id
  end
end