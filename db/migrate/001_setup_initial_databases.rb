class SetupInitialDatabases < ActiveRecord::Migration
  
  def self.up
    
    create_table 'users' do |t|
      t.column :salted_password,  :string,    :limit => 40, :default => "", :null => false
      t.column :email,            :string,    :limit => 60, :default => "", :null => false
      t.column :salt,             :string,    :limit => 40, :default => "", :null => false
      t.column :security_token,   :string,    :limit => 40
      t.column :token_expiry,     :datetime
      t.column :created_at,       :datetime
      t.column :updated_at,       :datetime
      t.column :logged_in_at,     :datetime
      t.column :verified,         :integer,   :default => false
      t.column :delete_after,     :datetime
      t.column :uuid,             :string,    :limit => 32, :null => false
    end
    add_index :users, [:uuid], :unique => true, :name => 'indx_users_uuid'
    add_index :users, [:email], :name => 'indx_users_email', :unique => true
    add_index :users, [:email,:salted_password], :name => 'indx_users_email_salted_password'
    
    
    create_table 'columns' do |t|
      t.column :user_id,          :integer,   :null => false
      t.column :position,         :integer,   :null => false
    end
    add_index :columns, :id, :name => 'indx_columns_id'
    add_index :columns, :user_id, :name => 'indx_columns_user_id'
    
    
    create_table 'boxes' do |t|
      t.column :column_id,        :integer,   :null => false
      t.column :title,            :string,    :limit => 64, :default => 'Rename Me...', :null => false
      t.column :style,            :string,    :limit => 16
      t.column :collapsed,        :boolean,   :default => false
      t.column :position,         :integer,   :null => false
    end
    add_index :boxes, :id, :name => 'indx_boxes_id'
    add_index :boxes, :column_id, :name => 'indx_boxes_column_id'
    
    
    create_table 'bookmarks' do |t|
      t.column :box_id,           :integer,   :null => false
      t.column :url,              :string,    :limit => 1024, :null => false
      t.column :name,             :string,    :limit => 255, :null => false
      t.column :created_at,       :datetime,  :null => false
      t.column :visited_at,       :datetime
      t.column :position,         :integer,   :null => false
    end
    add_index :bookmarks, :id, :name => 'indx_bookmarks_id'
    add_index :bookmarks, :box_id, :name => 'indx_bookmarks_box_id'
    
    
    create_table 'inboxes' do |t|
      t.column :user_id,          :integer,   :null => false
    end
    add_index :inboxes, :id, :name => 'indx_inboxes_id'
    add_index :inboxes, :user_id, :name => 'indx_inboxes_user_id'
    
    
    create_table 'inboxmarks' do |t|
      t.column :inbox_id,         :integer,   :null => false
      t.column :url,              :string,    :limit => 1024, :null => false
      t.column :name,             :string,    :limit => 255, :null => false
      t.column :created_at,       :datetime,  :null => false
      t.column :visited_at,       :datetime
      t.column :position,         :integer,   :null => false
    end
    add_index :inboxmarks, :id, :name => 'indx_inboxmarks_id'
    add_index :inboxmarks, :inbox_id, :name => 'indx_inboxmarks_inbox_id'
    
    
    create_table 'trashboxes' do |t|
      t.column :user_id,          :integer,   :null => false
    end
    add_index :trashboxes, :id, :name => 'indx_trashboxes_id'
    add_index :trashboxes, :user_id, :name => 'indx_trashboxes_user_id'
    
    
    create_table 'trashboxmarks' do |t|
      t.column :trashbox_id,      :integer,   :null => false
      t.column :url,              :string,    :limit => 1024, :null => false
      t.column :name,             :string,    :limit => 255, :null => false
      t.column :created_at,       :datetime,  :null => false
      t.column :visited_at,       :datetime
      t.column :position,         :integer,   :null => false
    end
    add_index :trashboxmarks, :id, :name => 'indx_trashmarks_id'
    add_index :trashboxmarks, :trashbox_id, :name => 'indx_trashmarks_trashbox_id'
    
    
    create_table 'support_requests' do |t|
      t.column :problem,          :string,    :null => false
      t.column :details,          :string,    :limit => 510, :null => false
      t.column :from_user,        :boolean,   :default => false, :null => false
      t.column :user_id,          :integer
      t.column :email,            :string,    :null => false
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

