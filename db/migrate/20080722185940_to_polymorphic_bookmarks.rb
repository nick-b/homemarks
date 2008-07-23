class ToPolymorphicBookmarks < ActiveRecord::Migration
  
  class Box < ActiveRecord::Base ; end
  class Bookmark < ActiveRecord::Base ; end
  class Inboxmark < ActiveRecord::Base ; end
  class Trashboxmark < ActiveRecord::Base ; end
  
  def self.up
    
    say_with_time 'Bookmarks to polymorphic' do
      remove_index  :bookmarks, :name => 'indx_bookmarks_box_id'
      rename_column :bookmarks, :box_id, :owner_id
      add_column    :bookmarks, :owner_type, :string, :limit => 48
      add_index     :bookmarks, [:owner_id, :owner_type], :name => 'indx_bookmarks_polyowner'
      Bookmark.update_all %|owner_type = 'Box'|
    end
    
    say_with_time 'Convert Inboxmarks to polymorphic bookmarks' do
      Inboxmark.all.each do |bm|
        Bookmark.create! :owner_id => bm.inbox_id, :owner_type => 'Inbox', :name => bm.name, :url => bm.url, 
                         :position => bm.position, :created_at => bm.created_at, :updated_at => Time.now
      end
      drop_table :inboxmarks
    end
    
    say_with_time 'Convert Trashboxmarks to polymorphic bookmarks' do
      Trashboxmark.all.each do |bm|
        Bookmark.create! :owner_id => bm.trashbox_id, :owner_type => 'Trashbox', :name => bm.name, :url => bm.url, 
                         :position => bm.position, :created_at => bm.created_at, :updated_at => Time.now
      end
      drop_table :trashboxmarks
    end
    
  end

  def self.down
    
    say_with_time 'Undo Trashboxmarks to polymorphic bookmarks' do
      create_table :trashboxmarks, :force => true do |t|
        t.integer  :trashbox_id,                 :null => false
        t.string   :url,         :limit => 1024, :null => false
        t.string   :name,                        :null => false
        t.datetime :created_at,                  :null => false
        t.integer  :position
      end
      add_index :trashboxmarks, [:id], :name => 'indx_trashmarks_id'
      add_index :trashboxmarks, [:trashbox_id], :name => 'indx_trashmarks_trashbox_id'
      Trashboxmark.reset_column_information
      Bookmark.all(:conditions => {:owner_type => 'Trashbox'}).each do |bm|
        Trashboxmark.create! :trashbox_id => bm.owner_id, :name => bm.name, :url => bm.url, 
                             :position => bm.position, :created_at => bm.created_at
      end
      Bookmark.delete_all %|owner_type = 'Trashbox'|
    end
    
    say_with_time 'Undo Inboxmarks to polymorphic bookmarks' do
      create_table :inboxmarks, :force => true do |t|
        t.integer  :inbox_id,                   :null => false
        t.string   :url,        :limit => 1024, :null => false
        t.string   :name,                       :null => false
        t.datetime :created_at,                 :null => false
        t.integer  :position
      end
      add_index :inboxmarks, [:id], :name => 'indx_inboxmarks_id'
      add_index :inboxmarks, [:inbox_id], :name => 'indx_inboxmarks_inbox_id'
      Inboxmark.reset_column_information
      Bookmark.all(:conditions => {:owner_type => 'Inbox'}).each do |bm|
        Inboxmark.create! :inbox_id => bm.owner_id, :name => bm.name, :url => bm.url, 
                          :position => bm.position, :created_at => bm.created_at
      end
      Bookmark.delete_all %|owner_type = 'Inbox'|
    end
    
    say_with_time 'Undo Bookmarks to polymorphic' do
      remove_index  :bookmarks, :name => 'indx_bookmarks_polyowner'
      remove_column :bookmarks, :owner_type
      rename_column :bookmarks, :owner_id, :box_id
      add_index     :bookmarks, [:box_id], :name => 'indx_bookmarks_box_id'
    end
    
  end
  
end
