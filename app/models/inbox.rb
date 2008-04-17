class Inbox < ActiveRecord::Base
  
  InboxForOptionGroup = Struct.new(:id, :title)
  
  belongs_to    :user
  has_many      :bookmarks, :order => :position, :dependent => :delete_all, :class_name => 'Inboxmark'
  
  attr_protected  :user_id
  
  
  
end
