class Column < ActiveRecord::Base
  
  belongs_to    :user
  acts_as_list  :scope => :user_id
  has_many      :boxes, :order => 'position'
  
  validates_presence_of   :user_id, :position
  attr_protected          :user_id, :position
  
  before_destroy :delete_all_associations
  
  
  protected
  
  def delete_all_associations
    Bookmark.delete_all :box_id => boxes.map(&:id)
    Box.delete_all :column_id => id
  end
  
  
end

