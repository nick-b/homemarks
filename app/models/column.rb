class Column < ActiveRecord::Base
  
  belongs_to    :user
  acts_as_list  :scope => :user_id
  has_many      :boxes, :order => :position, :dependent => :delete_all
  
  validates_presence_of   :user_id, :position
  
  attr_protected          :user_id, :position

  
  
  
  
  
end
