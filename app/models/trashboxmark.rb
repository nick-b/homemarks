class Trashboxmark < ActiveRecord::Base

  belongs_to    :trashbox
  acts_as_list  :scope => :trashbox_id
  
  validates_presence_of   :trashbox_id, :position
  validates_length_of     :url, :maximum => 1024
  validates_length_of     :name, :maximum => 255
  
  attr_protected          :trashbox_id, :position, :created_at
  
  
  
end
