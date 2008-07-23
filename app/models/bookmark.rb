class Bookmark < ActiveRecord::Base
  
  belongs_to    :owner, :polymorphic => true
  acts_as_list  :scope => %q|owner_id = #{owner_id} AND owner_type = '#{owner_type}'|, :scope_column => :owner_id
  
  validates_presence_of   :owner_id, :owner_type
  validates_length_of     :url, :maximum => 1024
  validates_length_of     :name, :maximum => 255
  
  attr_protected          :owner_id, :owner_type, :position, :created_at
  
  
  
  
end
