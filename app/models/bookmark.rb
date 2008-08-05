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
  
  def user
    @user ||= owner.user
  end
  
  def to_box(type_or_id,position=nil)
    box = case type_or_id
          when :inbox : user.inbox
          when :trashbox : user.trashbox
          else user.boxes.find(type_or_id)
          end
    self.class.transaction do
      remove_from_list
      self.owner = box
      if position
        insert_at_position(position.to_i)
      else
        increment_positions_on_all_items
        assume_top_position
      end
    end 
  end
  
  def trash!
    to_box(:trashbox) unless trashbox?
  end
  
  
  
end

