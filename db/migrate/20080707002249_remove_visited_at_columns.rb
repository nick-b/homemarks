class RemoveVisitedAtColumns < ActiveRecord::Migration

  def self.up
    remove_column :bookmarks, :visited_at
    remove_column :inboxmarks, :visited_at
    remove_column :trashboxmarks, :visited_at
  end

  def self.down
    add_column :bookmarks, :visited_at, :datetime
    add_column :inboxmarks, :visited_at, :datetime
    add_column :trashboxmarks, :visited_at, :datetime
  end

end
