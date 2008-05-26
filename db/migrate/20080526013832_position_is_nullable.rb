class PositionIsNullable < ActiveRecord::Migration
  
  # Lets ActAsList use #remove_from_list by nulling position column.
  
  def self.up
    change_column :bookmarks,     :position, :integer, :null => true
    change_column :boxes,         :position, :integer, :null => true
    change_column :columns,       :position, :integer, :null => true
    change_column :inboxmarks,    :position, :integer, :null => true
    change_column :trashboxmarks, :position, :integer, :null => true
  end

  def self.down
    change_column :bookmarks,     :position, :integer, :null => false
    change_column :boxes,         :position, :integer, :null => false
    change_column :columns,       :position, :integer, :null => false
    change_column :inboxmarks,    :position, :integer, :null => false
    change_column :trashboxmarks, :position, :integer, :null => false
  end
  
end
