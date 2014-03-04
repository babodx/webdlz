class CreateNameservers < ActiveRecord::Migration
  def change
    create_table :nameservers do |t|
      t.string :name
      t.integer :priority
      t.timestamps
    end
  end
end
