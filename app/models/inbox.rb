class Inbox < ActiveRecord::Base
  
  # FIXME: Test and/or move me.
  InboxForOptionGroup = Struct.new(:id, :title)
  
  belongs_to  :user
  has_many    :bookmarks, :class_name => 'Inboxmark', :foreign_key => 'inbox_id', :order => :position, :dependent => :delete_all
  
  attr_protected  :user_id
  
  
  
end
