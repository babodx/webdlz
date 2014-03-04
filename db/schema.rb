# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140225142024) do

  create_table "disabled_records", :force => true do |t|
    t.text     "zone"
    t.text     "host"
    t.integer  "ttl"
    t.text     "mx_priority"
    t.text     "data"
    t.text     "resp_person"
    t.integer  "serial"
    t.integer  "refresh"
    t.integer  "retry"
    t.integer  "expire"
    t.integer  "minimum"
    t.string   "record_type"
    t.integer  "user_id"
    t.datetime "last_edit_time"
    t.datetime "created_time"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "zonename_id"
  end

  add_index "disabled_records", ["data"], :name => "index_disabled_records_on_data"
  add_index "disabled_records", ["zone"], :name => "index_disabled_records_on_zone"

  create_table "dns_records", :id => false, :force => true do |t|
    t.text    "zone"
    t.text    "host"
    t.integer "ttl",         :limit => 8
    t.text    "mx_priority"
    t.text    "data"
    t.text    "resp_person"
    t.integer "serial",      :limit => 8
    t.integer "refresh",     :limit => 8
    t.integer "retry",       :limit => 8
    t.integer "expire",      :limit => 8
    t.integer "minimum",     :limit => 8
    t.integer "id",          :limit => 8, :null => false
    t.string  "record_type"
    t.integer "user_id"
  end

  add_index "dns_records", ["host"], :name => "host_index"

  create_table "nameservers", :force => true do |t|
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "active",     :default => true
  end

  create_table "records", :force => true do |t|
    t.text     "zone"
    t.text     "host"
    t.integer  "ttl"
    t.text     "mx_priority"
    t.text     "data"
    t.text     "resp_person"
    t.integer  "serial"
    t.integer  "refresh"
    t.integer  "retry"
    t.integer  "expire"
    t.integer  "minimum"
    t.string   "record_type"
    t.integer  "user_id"
    t.datetime "last_edit_time"
    t.datetime "created_time"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "zonename_id"
  end

  add_index "records", ["data"], :name => "index_records_on_data"
  add_index "records", ["zone"], :name => "index_records_on_zone"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "wmid",                   :limit => 12
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["wmid"], :name => "index_users_on_wmid", :unique => true

  create_table "users_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users_roles", ["role_id"], :name => "index_users_roles_on_role_id"
  add_index "users_roles", ["user_id"], :name => "index_users_roles_on_user_id"

  create_table "users_zonenames", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "zonename_id"
  end

  create_table "xfr_table", :force => true do |t|
    t.string   "zone"
    t.string   "client"
    t.integer  "zonename_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "zonenames", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "last_edit_user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
