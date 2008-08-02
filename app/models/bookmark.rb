class Bookmark < ActiveRecord::Base
  
  OWNER_TYPES = ['Box','Inbox','Trashbox'].freeze
  
  belongs_to    :owner, :polymorphic => true
  acts_as_list  :scope => %q|owner_id = #{owner_id} AND owner_type = '#{owner_type}'|, :scope_column => :owner_id
  
  validates_presence_of   :owner_id, :owner_type
  validates_length_of     :url, :maximum => 1024
  validates_length_of     :name, :maximum => 255
  validates_inclusion_of  :owner_type, :in => OWNER_TYPES
  
  attr_protected          :owner_id, :owner_type, :position, :created_at
  
  
  OWNER_TYPES.each do |type|
    define_method "#{type.downcase}?" do
      owner_type == type
    end
  end
  
  def to_box(box)
    self.class.transaction do
      remove_from_list
      self.owner = box
      
      increment_positions_on_all_items
      assume_top_position
      # increment_positions_on_all_items
    end unless trashbox?
  end
  
  def user
    
  end
  
  def trash!
    to_box(self)
  end
  
  
  
end


# bx = Box.first
# bm = bx.bookmarks.first
# 
# bm.remove_from_list
# bm.owner_type = 'Trashbox'