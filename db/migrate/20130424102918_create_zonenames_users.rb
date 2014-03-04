class CreateZonenamesUsers < ActiveRecord::Migration
  def self.up
    create_table :users_zonenames, :id => false do |t|
      t.integer :user_id
      t.integer :zonename_id
    end
  end

  def self.down
    drop_table :users_zonenames
  end
end
