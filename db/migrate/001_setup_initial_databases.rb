class SetupInitialDatabases < ActiveRecord::Migration
  
  def self.up
    
    create_table "users", :force => true do |t|
      t.string   :salted_password, :limit => 40, :default => "", :null => false
      t.string   :email,           :limit => 60, :default => "", :null => false
      t.string   :salt,            :limit => 40, :default => "", :null => false
      t.string   :security_token,  :limit => 40
      t.datetime :token_expiry
      t.datetime :logged_in_at
      t.integer  :verified,                      :default => 0
      t.integer  :deleted,                       :default => 0
      t.datetime :delete_after
      t.string   :uuid,            :limit => 32,                 :null => false
      t.timestamps
    end
    add_index :users, ["email", "salted_password"], :name => "indx_users_email_salted_password"
    add_index :users, ["email"], :name => "indx_users_email", :unique => true
    add_index :users, ["uuid"], :name => "indx_users_uuid", :unique => true
    
    
    create_table "columns", :force => true do |t|
      t.integer :user_id,  :null => false
      t.integer :position, :null => false
    end
    add_index :columns, ["user_id"], :name => "indx_columns_user_id"
    add_index :columns, ["id"], :name => "indx_columns_id"


    create_table "boxes", :force => true do |t|
      t.integer :column_id,                                           :null => false
      t.string  :title,     :limit => 64, :default => "Rename Me...", :null => false
      t.string  :style,     :limit => 16
      t.boolean :collapsed,               :default => false
      t.integer :position,                                            :null => false
    end
    add_index :boxes, ["column_id"], :name => "indx_boxes_column_id"
    add_index :boxes, ["id"], :name => "indx_boxes_id"


    create_table "bookmarks", :force => true do |t|
      t.integer  :box_id,                     :null => false
      t.string   :url,        :limit => 1024, :null => false
      t.string   :name,                       :null => false
      t.datetime :visited_at
      t.integer  :position,                   :null => false
      t.timestamps
    end
    add_index :bookmarks, ["box_id"], :name => "indx_bookmarks_box_id"
    add_index :bookmarks, ["id"], :name => "indx_bookmarks_id"

    
    create_table "inboxes", :force => true do |t|
      t.integer :user_id, :null => false
    end
    add_index :inboxes, ["user_id"], :name => "indx_inboxes_user_id"
    add_index :inboxes, ["id"], :name => "indx_inboxes_id"


    create_table "inboxmarks", :force => true do |t|
      t.integer  :inbox_id,                   :null => false
      t.string   :url,        :limit => 1024, :null => false
      t.string   :name,                       :null => false
      t.datetime :created_at,                 :null => false
      t.datetime :visited_at
      t.integer  :position,                   :null => false
    end
    add_index :inboxmarks, ["inbox_id"], :name => "indx_inboxmarks_inbox_id"
    add_index :inboxmarks, ["id"], :name => "indx_inboxmarks_id"

    
    create_table "trashboxes", :force => true do |t|
      t.integer :user_id, :null => false
    end
    add_index :trashboxes, ["user_id"], :name => "indx_trashboxes_user_id"
    add_index :trashboxes, ["id"], :name => "indx_trashboxes_id"
    
    
    create_table "trashboxmarks", :force => true do |t|
      t.integer  :trashbox_id,                 :null => false
      t.string   :url,         :limit => 1024, :null => false
      t.string   :name,                        :null => false
      t.datetime :created_at,                  :null => false
      t.datetime :visited_at
      t.integer  :position,                    :null => false
    end
    add_index :trashboxmarks, ["trashbox_id"], :name => "indx_trashmarks_trashbox_id"
    add_index :trashboxmarks, ["id"], :name => "indx_trashmarks_id"
    
    
    create_table "support_requests", :force => true do |t|
      t.string  :problem,                                     :null => false
      t.string  :details,   :limit => 510,                    :null => false
      t.boolean :from_user,                :default => false, :null => false
      t.integer :user_id
      t.string  :email,                                       :null => false
    end
    
  end
  
  def self.down
    drop_table :users
    drop_table :columns
    drop_table :boxes
    drop_table :bookmarks
    drop_table :inboxes
    drop_table :inboxmarks
    drop_table :trashboxes
    drop_table :trashboxmarks
    drop_table :support_requests
  end
  
  
end

