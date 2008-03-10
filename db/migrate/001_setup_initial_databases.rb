
# create_table(name, options = {}) {|t| ...}
# --------------------------------------------------------------------------------------------------------------
#  :id           Set to true or false to add/not add a primary key column automatically. Defaults to true.
#  :primary_key  The name of the primary key, if one is to be added automatically. Defaults to id.
#  :options      Any extra options you want appended to the table definition.
#  :temporary    Make a temporary table.
#  :force        Set to true or false to drop the table before creating it. Defaults to false.
# 
# column(name, type, options = {})
# --------------------------------------------------------------------------------------------------------------
#  :primary_key, :string, :text, :integer, :float, :datetime, :timestamp, :time, :date, :binary, :boolean.
# 
#  :limit    Requests a maximum column length (:string, :text, :binary or :integer columns only)
#  :default  The column’s default value. You cannot explicitely set the default value to NULL.
#            Simply leave off this option if you want a NULL default value.
#  :null     Allows or disallows NULL values in the column. This option could have been named :null_allowed.

class SetupInitialDatabases < ActiveRecord::Migration
  def self.up
    
    create_table "users" do |t|
      t.column "login", :string, :limit => 80, :default => "", :null => false
      t.column "salted_password", :string, :limit => 40, :default => "", :null => false
      t.column "email", :string, :limit => 60, :default => "", :null => false
      t.column "firstname", :string, :limit => 40
      t.column "lastname", :string, :limit => 40
      t.column "salt", :string, :limit => 40, :default => "", :null => false
      t.column "verified", :integer, :default => 0
      t.column "role", :string, :limit => 40
      t.column "security_token", :string, :limit => 40
      t.column "token_expiry", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "logged_in_at", :datetime
      t.column "deleted", :integer, :default => 0
      t.column "delete_after", :datetime
    end
    

    create_table "sessions" do |t|
      t.column "sessid", :string
      t.column "data", :text
      t.column "updated_at", :datetime
    end
    add_index :sessions, :sessid, :name => "indx_sessions_sessid"
    
    
    create_table "columns" do |t|
      t.column "user_id", :integer, :null => false
      t.column "position", :integer, :null => false
    end
    execute "ALTER TABLE columns ADD CONSTRAINT fkey_columns_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE"
    add_index :columns, :id, :name => "indx_columns_id"
    add_index :columns, :user_id, :name => "fki_columns_user_id"
    
    
    create_table "boxes" do |t|
      t.column "column_id", :integer, :null => false
      t.column "title", :string, :limit => 64, :default => "Rename Me...", :null => false
      t.column "style", :string, :limit => 16
      t.column "collapsed", :boolean, :default => "0", :null => false  # Postgres (:default => "false")
      t.column "position", :integer, :null => false
    end
    execute "ALTER TABLE boxes ADD CONSTRAINT fkey_boxes_column_id FOREIGN KEY (column_id) REFERENCES columns (id) ON UPDATE CASCADE ON DELETE CASCADE"
    add_index :boxes, :id, :name => "indx_boxes_id"
    add_index :boxes, :column_id, :name => "fki_boxes_column_id"
    
    
    create_table "bookmarks" do |t|
      t.column "box_id", :integer, :null => false
      t.column "url", :string, :limit => 1024, :null => false
      t.column "name", :string, :limit => 255, :null => false
      t.column "created_at", :datetime, :null => false
      t.column "visited_at", :datetime
      t.column "position", :integer, :null => false
    end
    execute "ALTER TABLE bookmarks ADD CONSTRAINT fkey_bookmarks_box_id FOREIGN KEY (box_id) REFERENCES boxes (id) ON UPDATE CASCADE ON DELETE CASCADE"
    add_index :bookmarks, :id, :name => "indx_bookmarks_id"
    add_index :bookmarks, :box_id, :name => "fki_bookmarks_box_id"
    
  end

  def self.down
    drop_table :bookmarks
    drop_table :boxes
    drop_table :columns
    drop_table :sessions
    drop_table :users
  end
  
end

