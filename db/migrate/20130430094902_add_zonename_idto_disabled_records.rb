class AddZonenameIdtoDisabledRecords < ActiveRecord::Migration
  def up
    add_column :disabled_records, :zonename_id, :integer
  end

  def down
    remove_column :disabled_records, :zonename_id
  end
end
