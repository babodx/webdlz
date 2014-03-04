class CreateXfrTable < ActiveRecord::Migration
  def up
    create_table :xfr_table do |t|
      t.string :zone
      t.string :client
      t.integer :zonename_id
      t.timestamps
    end
  end

  def down
  end
end
