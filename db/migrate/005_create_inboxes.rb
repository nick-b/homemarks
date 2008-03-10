class CreateInboxes < ActiveRecord::Migration
  
  class User < ActiveRecord::Base ; has_one :inbox ; end
  
  def self.up
    
    create_table :inboxes do |t|
      t.column 'user_id', :integer, :null => false
    end
    execute 'ALTER TABLE inboxes ADD CONSTRAINT fkey_inboxes_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE'
    add_index :inboxes, :id, :name => 'indx_inboxes_id'
    add_index :inboxes, :user_id, :name => 'fki_inboxes_user_id'
    
    create_table :inboxmarks do |t|
      t.column 'inbox_id', :integer, :null => false
      t.column 'url', :string, :limit => 1024, :null => false
      t.column 'name', :string, :limit => 255, :null => false
      t.column 'created_at', :datetime, :null => false
      t.column 'visited_at', :datetime
      t.column 'position', :integer, :null => false
    end
    execute 'ALTER TABLE inboxmarks ADD CONSTRAINT fkey_inboxmarks_inbox_id FOREIGN KEY (inbox_id) REFERENCES inboxes (id) ON UPDATE CASCADE ON DELETE CASCADE'
    add_index :inboxmarks, :id, :name => 'indx_inboxmarks_id'
    add_index :inboxmarks, :inbox_id, :name => 'fki_inboxmarks_inbox_id'
    
    User.find(:all).each do |user|
      user.create_inbox
    end
    
  end

  def self.down
    drop_table :inboxes
    drop_table :inboxmarks
  end

end
