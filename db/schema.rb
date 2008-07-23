# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080722185940) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "owner_id",                   :null => false
    t.string   "url",        :limit => 1024, :null => false
    t.string   "name",                       :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type", :limit => 48
  end

  add_index "bookmarks", ["owner_id", "owner_type"], :name => "indx_bookmarks_polyowner"
  add_index "bookmarks", ["id"], :name => "indx_bookmarks_id"

  create_table "boxes", :force => true do |t|
    t.integer "column_id",                                           :null => false
    t.string  "title",     :limit => 64, :default => "Rename Me..."
    t.string  "style",     :limit => 16
    t.boolean "collapsed",               :default => false
    t.integer "position"
  end

  add_index "boxes", ["id"], :name => "indx_boxes_id"
  add_index "boxes", ["column_id"], :name => "indx_boxes_column_id"

  create_table "columns", :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "position"
  end

  add_index "columns", ["id"], :name => "indx_columns_id"
  add_index "columns", ["user_id"], :name => "indx_columns_user_id"

  create_table "inboxes", :force => true do |t|
    t.integer "user_id", :null => false
  end

  add_index "inboxes", ["id"], :name => "indx_inboxes_id"
  add_index "inboxes", ["user_id"], :name => "indx_inboxes_user_id"

  create_table "support_requests", :force => true do |t|
    t.string  "problem",                :null => false
    t.string  "details", :limit => 510, :null => false
    t.integer "user_id"
    t.string  "email",                  :null => false
  end

  create_table "trashboxes", :force => true do |t|
    t.integer "user_id", :null => false
  end

  add_index "trashboxes", ["id"], :name => "indx_trashboxes_id"
  add_index "trashboxes", ["user_id"], :name => "indx_trashboxes_user_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password", :limit => 40, :default => "",    :null => false
    t.string   "email",            :limit => 60, :default => "",    :null => false
    t.string   "salt",             :limit => 40, :default => "",    :null => false
    t.string   "security_token",   :limit => 40
    t.datetime "token_expiry"
    t.datetime "logged_in_at"
    t.boolean  "verified",                       :default => false
    t.boolean  "deleted",                        :default => false
    t.datetime "delete_after"
    t.string   "uuid",             :limit => 32,                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uuid"], :name => "indx_users_uuid", :unique => true
  add_index "users", ["email"], :name => "indx_users_email", :unique => true
  add_index "users", ["email", "crypted_password"], :name => "indx_users_email_crypted_password"

end
