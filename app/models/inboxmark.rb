class Inboxmark < ActiveRecord::Base

  belongs_to    :inbox
  acts_as_list  :scope => :inbox_id
  
  validates_presence_of   :inbox_id, :position
  validates_length_of     :url, :maximum => 1024
  validates_length_of     :name, :maximum => 255
  
  attr_protected          :inbox_id, :position, :created_at
  
  
  
end
