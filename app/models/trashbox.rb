class Trashbox < ActiveRecord::Base

  belongs_to  :user
  has_many  :bookmarks, :class_name => 'Bookmark', :as => :owner, :order => 'position', :dependent => :delete_all
  
  attr_protected :user_id
  
  
  def empty?
    bookmarks.count == 0
  end
  
  
end
