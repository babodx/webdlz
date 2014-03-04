class AddWmidToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :wmid, :string, :limit => 12

    add_index :users, :wmid, :unique => true
  end

  def self.down
    remove_column :users, :wmid
  end
end
