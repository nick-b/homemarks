class Inbox < ActiveRecord::Base
  
  OptGroup = Struct.new(:id, :title)
  
  belongs_to  :user
  has_many    :bookmarks, :class_name => 'Bookmark', :as => :owner, :order => 'position', :dependent => :delete_all
  
  attr_protected  :user_id
  
  class << self
    
    def optgroup
      Box::OptGroup.new [OptGroup.new('inbox','My Inbox')], 'INBOX'
    end
    
  end
  
  
  
end
