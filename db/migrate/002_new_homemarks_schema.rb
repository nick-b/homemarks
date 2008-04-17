class NewHomemarksSchema < ActiveRecord::Migration
  
  def self.up
    # Chaning password field
    rename_column :users, :salted_password, :crypted_password
    remove_index :users, :name => 'indx_users_email_salted_password'
    add_index :users, ['email','crypted_password'], :name => 'indx_users_email_crypted_password'
    # User verified to boolean
    change_column :users, :verified, :boolean, :default => false
    change_column :users, :deleted, :boolean, :default => false
  end
  
  def self.down
    # Chaning password field
    rename_column :users, :crypted_password, :salted_password
    remove_index :users, :name => 'indx_users_email_crypted_password'
    add_index :users, ['email','salted_password'], :name => 'indx_users_email_salted_password'
    # User verified to boolean
    change_column :users, :verified, :integer, :default => 0
    change_column :users, :deleted, :integer, :default => 0
  end
    
end

