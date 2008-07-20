class User < ActiveRecord::Base
  
  has_one   :inbox
  has_one   :trashbox
  has_many  :columns, :order => 'position'
  has_many  :boxes, :through => :columns, :order => 'columns.position, boxes.position' do
    def bookmark(id) ; Bookmark.find id, :conditions => {:box_id => all.map(&:id)} ; end
  end
  has_many  :support_requests
  
  validates_presence_of     :email
  validates_uniqueness_of   :uuid, :email
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  
  attr_accessor   :password, :password_confirmation
  attr_reader     :custom_changed_cache
  attr_accessible :email, :password, :password_confirmation
  
  before_validation_on_create :build_standard_boxes, :generate_security_token
  after_validation            :crypt_password, :create_uuid
  before_update               :backup_dirty_changes
  before_destroy              :delete_all_associations
  
  
  class << self
    
    def authenticate(email, password)
      if user = find_by_email_and_verified_and_deleted(email,true,false)
        user.logged_in_at = Time.now ; user.save!
      end
      user.blank? ? nil : find_by_email_and_crypted_password(email,user.send(:encrypt,password))
    end
    
    def authenticate_by_token(token)
      if user = find(:first, :conditions => ['security_token = ? AND token_expiry > ?', token, Time.now]) rescue nil
        user.logged_in_at = Time.now ; user.verified = true ; user.deleted = false ; user.save!
      end
      user
    end
    
    def email_exists?(email)
      count(:conditions => ['email LIKE ?',email]) > 0
    end
    
    def encrypt(password, salt)
      Digest::SHA1.hexdigest "--#{salt}--#{password}--"
    end
    
  end
  
  
  def generate_security_token(force_update=false)
    self.token_expiry = deleted? ? HmConfig.app[:delayed_delete_days].days.from_now : 1.day.from_now
    self.security_token = encrypt(email+token_expiry.to_s)
    self.verified = false
    save! if force_update
    security_token
  end
  
  def delete!
    self.deleted = true
    self.delete_after = HmConfig.app[:delayed_delete_days].days.from_now
    generate_security_token
    save!
  end
  
  
  # FIXME: Test and/or move me.
  
  BoxesForOptionGroup = Struct.new(:boxes, :col_name)
  
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
  
  def encrypt(password)
    self.class.encrypt(password,salt)
  end
  
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
  
  def backup_dirty_changes
    @custom_changed_cache = self.changes.with_indifferent_access
  end
  
  def delete_all_associations
    inbox.destroy
    trashbox.destroy
    columns.each(&:destroy)
  end
  
  
end
