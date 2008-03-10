class Bookmark < ActiveRecord::Base
  
  belongs_to    :box
  acts_as_list  :scope => :box_id
  
  validates_presence_of   :box_id, :position
  validates_length_of     :url, :maximum => 1024
  validates_length_of     :name, :maximum => 255
  
  attr_protected          :box_id, :position, :created_at, :visited_at
  
  
  def self.find_all_via_users_boxes(user,params)
    user.boxes.find :all, :conditions => ['bookmarks.id IN (?)', params], :include => :bookmarks
  end
  
  def self.find_via_users_boxes(user,id)
    user.boxes.find(:first, :conditions => ['bookmarks.id = ?', id], :include => :bookmarks).bookmarks[0]
  end
  
  
  
end
