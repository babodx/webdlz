class AddPIdToXfr < ActiveRecord::Migration
  def up
    add_column :xfr_table, :id, :primary_key
  end

  def down
    remove_column :xfr_table, :id
  end
end