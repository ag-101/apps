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

ActiveRecord::Schema.define(:version => 20140324133013) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "app_type"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "slug"
  end

  create_table "constructs", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "app_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "published",      :limit => 1, :default => 0
    t.integer  "disabled",       :limit => 1, :default => 0
    t.integer  "workflow_id"
    t.text     "message_before"
    t.text     "message_after"
  end

  create_table "helps", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "homes", :force => true do |t|
    t.text     "content"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "created_by_id", :null => false
    t.integer  "updated_by_id", :null => false
    t.integer  "app_id"
    t.string   "page_type"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "app_id"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "submissions", :force => true do |t|
    t.text     "content"
    t.integer  "construct_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "draft",         :limit => 1
  end

  create_table "users", :force => true do |t|
    t.string   "login",               :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "remember_token"
    t.string   "email"
    t.string   "name"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "workflow_contents", :force => true do |t|
    t.integer  "workflow_stage_id"
    t.integer  "submission_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "status"
    t.text     "comment"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "workflow_stages", :force => true do |t|
    t.integer  "workflow_id"
    t.integer  "stage"
    t.integer  "send_to_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "info_only",     :limit => 1, :default => 0
  end

  create_table "workflows", :force => true do |t|
    t.string   "name"
    t.integer  "app_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
