class CreateRecordsTable < ActiveRecord::Migration
  def change
    create_table(:records) do |t|
      ## Database authenticatable
      t.text  :zone
      t.text  :host
      t.integer :ttl
      t.text  :mx_priority
      t.text  :data
      t.text  :resp_person
      t.integer :serial
      t.integer :refresh
      t.integer :retry
      t.integer :expire
      t.integer :minimum
      t.string  :record_type
      t.integer :user_id

      t.datetime :last_edit_time
      t.datetime :created_time
      t.timestamps
    end

    add_index :records, :zone
    add_index :records, :data
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end
end
