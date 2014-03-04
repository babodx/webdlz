class CreateDisabledRecords < ActiveRecord::Migration
  def change
    create_table(:disabled_records) do |t|
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

    add_index :disabled_records, :zone
    add_index :disabled_records, :data
  end
end
