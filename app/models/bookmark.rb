class Bookmark < ActiveRecord::Base
  
  belongs_to    :box
  acts_as_list  :scope => :box_id
  
  validates_presence_of   :box_id, :position
  validates_length_of     :url, :maximum => 1024
  validates_length_of     :name, :maximum => 255
  
  attr_protected          :owner_id, :owner_type, :position, :created_at
  
  
  
  
end
