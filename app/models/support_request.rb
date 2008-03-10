class SupportRequest < ActiveRecord::Base
  
  SUPPORT_OPTIONS = [
    'Account Issues',
    'Issues With My HomeMarks Page',
    'Using The HomeMarklet',
    'New Feature Request',
    'Other...'
    ]
  
  validates_presence_of   :problem
  validates_presence_of   :details
  validates_presence_of   :email
  validates_inclusion_of  :problem, :in => SUPPORT_OPTIONS
  
  attr_protected        :from_user, :user_id
  



end
