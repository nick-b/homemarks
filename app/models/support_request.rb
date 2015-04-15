class SupportRequest < ActiveRecord::Base

  SUPPORT_OPTIONS = [
    'Account Issues',
    'Issues With My HomeMarks Page',
    'Using The HomeMarklet',
    'New Feature Request',
    'Other...'
    ].freeze

  belongs_to :user

  validates_presence_of   :problem, :details, :email
  validates_inclusion_of  :problem, :in => SUPPORT_OPTIONS, :message => 'is invalid'

  attr_protected          :user_id




end
