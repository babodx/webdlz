class CreateZonenames < ActiveRecord::Migration
  def change
    create_table :zonenames do |t|
      t.string :name
      t.integer :user_id
      t.integer :last_edit_user_id
      t.timestamps
    end
  end
end
