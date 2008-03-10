class OverhaulUsers < ActiveRecord::Migration

  def self.up
    say_with_time "Waiting 10 seconds... irreversible migration ahead. Overhauling users table." do
      sleep 10
    end
    say_with_time "Setting email/salted_password inexes." do
      add_index :users, [:email], :name => "indx_users_email", :unique => true
      add_index :users, [:email,:salted_password], :name => "indx_users_email_salted_password"
    end
    say_with_time "Removing uneeded columns - [:login, :firstname, :lastname, :role]" do
      remove_column :users, :login
      remove_column :users, :firstname
      remove_column :users, :lastname
      remove_column :users, :role
    end
    say_with_time "Chaging [:deleted, :verified] to boolean columns" do
      change_column :users, :deleted, :boolean, :default => 0
      change_column :users, :verified, :boolean, :default => 0
    end
    
  end

  def self.down
    raise IrreversibleMigration
  end

end
