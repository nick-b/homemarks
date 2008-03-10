class Inbox < ActiveRecord::Base
  
  InboxForOptionGroup = Struct.new(:id, :title)
  
  belongs_to    :user
  has_many      :bookmarks, :order => :position, :dependent => :delete_all, :class_name => 'Inboxmark'
  
  validates_presence_of   :user_id
  attr_protected          :user_id
  
  
  
end
