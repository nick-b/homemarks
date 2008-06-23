class FixNullColumns < ActiveRecord::Migration
  
  def self.up
    change_column :boxes, :title, :string, :null => true
  end

  def self.down
    change_column :boxes, :title, :string, :null => false
  end
  
end
