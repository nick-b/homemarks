class AddUserUuid < ActiveRecord::Migration

  def self.up
    add_column "users", "uuid", :string, :limit => 42, :null => false
    add_index :users, [:uuid], :unique => true, :name => 'indx_users_uuid'
  end
  

  def self.down
    remove_column "users", "uuid"
  end

end
