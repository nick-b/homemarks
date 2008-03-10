class ChangeUuidColumn < ActiveRecord::Migration

  def self.up
    change_column :users, :uuid, :string, :limit => 32, :null => false
  end

  def self.down
    change_column :users, :uuid, :string, :limit => 32, :null => false
  end

end
