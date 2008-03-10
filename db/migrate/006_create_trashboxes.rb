class CreateTrashboxes < ActiveRecord::Migration

  class User < ActiveRecord::Base ; has_one :trashbox ; end
  
  def self.up
    
    create_table :trashboxes do |t|
      t.column 'user_id', :integer, :null => false
    end
    execute 'ALTER TABLE trashboxes ADD CONSTRAINT fkey_trashboxes_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE'
    add_index :trashboxes, :id, :name => 'indx_trashboxes_id'
    add_index :trashboxes, :user_id, :name => 'fki_trashboxes_user_id'
    
    create_table :trashboxmarks do |t|
      t.column 'trashbox_id', :integer, :null => false
      t.column 'url', :string, :limit => 1024, :null => false
      t.column 'name', :string, :limit => 255, :null => false
      t.column 'created_at', :datetime, :null => false
      t.column 'visited_at', :datetime
      t.column 'position', :integer, :null => false
    end
    execute 'ALTER TABLE trashboxmarks ADD CONSTRAINT fkey_trashboxmarks_trashbox_id FOREIGN KEY (trashbox_id) REFERENCES trashboxes (id) ON UPDATE CASCADE ON DELETE CASCADE'
    add_index :trashboxmarks, :id, :name => 'indx_trashmarks_id'
    add_index :trashboxmarks, :trashbox_id, :name => 'fki_trashmarks_trashbox_id'
    
    User.find(:all).each do |user|
      user.create_trashbox
    end
    
  end

  def self.down
    drop_table :trashboxes
    drop_table :trashboxmarks
  end
  
  
end
