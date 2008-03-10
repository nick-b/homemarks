class Trashbox < ActiveRecord::Base

  belongs_to    :user
  has_many      :bookmarks, :order => :position, :dependent => :delete_all, :class_name => 'Trashboxmark'
  
  validates_presence_of   :user_id
  attr_protected          :user_id
  
  
  def is_empty?
    count = self.bookmarks.count
    return false if (count > 0)
    return true if (count == 0)
  end
  
  
  
end
