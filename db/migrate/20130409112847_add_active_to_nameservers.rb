class AddActiveToNameservers < ActiveRecord::Migration
  def up
    add_column :nameservers, :active, :boolean, :default => true
  end

  def down
    remove_column :nameservers, :active
  end
end
