class CreateSupportRequests < ActiveRecord::Migration

  def self.up
    create_table :support_requests do |t|
      t.column :problem, :string, :null => false
      t.column :details, :string, :limit => 510, :null => false
      t.column :from_user, :boolean, :default => false, :null => false
      t.column :user_id, :integer
      t.column :email, :string, :null => false
    end
  end

  def self.down
    drop_table :support_requests
  end
  
end
