require 'digest/sha1'

class User < ActiveRecord::Base
  
  BoxesForOptionGroup = Struct.new(:boxes, :col_name)
  
  has_one   :inbox
  has_one   :trashbox
  has_many  :columns, :order => :position
  has_many  :boxes, :through => :columns, :order => 'columns.position, boxes.position'
  has_many  :support_requests
  
  validates_presence_of     :email, :salt, :crypted_password, :uuid
  validates_uniqueness_of   :uuid, :email
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  
  attr_accessor  :password, :password_confirmation
  attr_accessible :email, :password, :password_confirmation
  
  before_validation           :crypt_password, :create_uuid
  before_validation_on_create :build_standard_boxes
  after_create                :generate_security_token!
  before_destroy              :delete_all_associations
  
  
  class << self
    
    def authenticate(email, password)
      u = find_by_email_and_verified_and_deleted(email,true,false)
      u.blank? ? nil : find_by_email_and_crypted_password(email, u.encrypt(password))
    end
    
    def authenticate_by_token(id, token)
      user = find(id, :conditions => ['security_token = ? AND token_expiry < ?',token,Time.now]) rescue nil
      user.update_attribute(:verified,true) unless user.blank?
      user
    end
    
    def email_exists?(email)
      count(:conditions => ['email LIKE ?',email]) > 0
    end
    
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
    
  end
  
  
  def encrypt(password)
    self.class.encrypt(password,salt)
  end
  
  def generate_security_token!
    self.token_expiry = Time.at(Time.now + (deleted? ? HmConfig.app[:delayed_delete_days].days : HmConfig.app[:token_life]))
    self.security_token = encrypt(email+token_expiry.to_s)
    self.verified = false
    save! and return security_token
  end
  
  def delete!
    self.deleted = true
    self.delete_after = HmConfig.app[:delayed_delete_days].days.from_now
    generate_security_token!
  end
  
  def column_containment_array
    @column_array ||= self.columns.collect {|col| "col_#{col.id}"}
  end
  
  def box_containment_array
    @box_array ||= self.boxes.find(:all).collect{|box|"boxid_list_#{box.id}"}.push('inbox_list','trashbox_list')
  end
  
  def boxes_for_option_group
    collection = []
    collection << BoxesForOptionGroup.new([Inbox::InboxForOptionGroup.new('inbox','My Inbox')], "INBOX")
    self.columns.each do |col|
      boxes = col.boxes
      collection << BoxesForOptionGroup.new(boxes, "Column #{col.position}")
    end
    collection
  end
  
  
  protected
  
  # def validate
  #   errors.add(:inbox,'was not created') unless inbox
  #   errors.add(:trashbox_list,'was not created') unless trashbox
  # end
  
  def crypt_password
    self.salt = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join ) if new_record?
    self.crypted_password = encrypt(password) if password_required?
  end
  
  def create_uuid
    self.uuid = UUID.new(:compact) if uuid.blank?
  end
  
  def build_standard_boxes
    build_inbox and build_trashbox
  end
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end
  
  # TODO: CASCADE DELETE: Verify Me.
  def delete_all_associations
    inbox.destroy
    trashbox.destroy
    columns(true).each(&:destroy)
  end
  
  
end
