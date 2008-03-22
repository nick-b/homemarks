require 'digest/sha1'

class User < ActiveRecord::Base
  
  BoxesForOptionGroup = Struct.new(:boxes, :col_name)
  
  has_one   :inbox
  has_one   :trashbox
  has_one   :inbox_with_bookmarks, :class_name => 'Inbox', :include => :bookmarks, :order => :position
  has_one   :trashbox_with_bookmarks, :class_name => 'Trashbox', :include => :bookmarks, :order => :position
  has_many  :columns, :order => :position, :dependent => :delete_all  
  has_many  :boxes, :through => :columns, :order => 'columns.position, boxes.position'
  has_many  :support_requests
  
  validates_uniqueness_of   :uuid
  validates_uniqueness_of   :email
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_presence_of     :password, :if => :validate_password?
  validates_confirmation_of :password, :if => :validate_password?
  validates_length_of       :password, :minimum => 5, :if => :validate_password?
  validates_length_of       :password, :maximum => 40, :if => :validate_password?
  
  attr_accessor  :password, :new_password, :password_confirmation
  attr_protected :verified, :created_at, :updated_at, :logged_in_at, :deleted, :delete_after, :uuid, :salt, :salted_password, :security_token, :token_expiry
  
  after_validation            :crypt_password
  after_validation_on_create  :create_uuid, :create_standard_boxes
  after_save                  :falsify_new_password
  before_destroy              :delete_all_associations
  
  
  def initialize(attributes = nil)
    super
    @new_password = true
  end
  
  def self.authenticate(email, pass)
    u = find_by_email_and_verified_and_deleted(email, true, false)
    return nil if u.nil?
    find_by_email_and_salted_password_and_verified(email, self.hash_string(u.salt + self.hash_string(pass)), true)
  end
  
  def self.authenticate_by_token(id, token)
    u = find_by_id_and_security_token(id,token)
    return nil if u.nil? or (Time.now > u.token_expiry)
    u.verified = true and u.save
    return u
  end
  
  def self.email_exists(email)
    testcount = count(:conditions => {:email => email})
    return true if (testcount > 0)
    return false
  end
  
  protected
  
  def self.hash_string(str)
    Digest::SHA1.hexdigest("#{HmConfig.app[:salt]}--#{str}--}")[0..39]
  end
  
  
  public
  
  def generate_security_token(force = false)
    return new_security_token if self.security_token.nil? or force
    return self.security_token
  end
  
  def change_password(pass, confirm = nil)
    self.password = pass
    self.password_confirmation = confirm.nil? ? pass : confirm
    @new_password = true
    self.save!
  end
  
  def set_delete_after
    self.deleted = true
    self.delete_after = Time.at(Time.now + HmConfig.app[:delayed_delete_days].days)
    return new_security_token(true)
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
  
  def crypt_password
    if @new_password
      self.salt = User.hash_string("salt-#{Time.now}")
      self.salted_password = User.hash_string(self.salt + User.hash_string(@password))
    end
  end
  
  def create_uuid
    self.uuid = UUID.new(:compact)
  end
  
  def create_standard_boxes
    self.create_inbox
    self.create_trashbox
  end
  
  def falsify_new_password
    @new_password = false
    true
  end
  
  def new_security_token(from_delete = false)
    self.security_token = User.hash_string(self.salted_password + Time.now.to_i.to_s + rand.to_s)
    self.token_expiry = Time.at(Time.now + (from_delete ? HmConfig.app[:delayed_delete_days].days : HmConfig.app[:token_life]))
    self.verified = false
    self.save
    return self.security_token
  end
  
  def validate_password?
    @new_password
  end
  
  
  private
  
  # TODO: CASCADE DELETE: Verify Me.
  def delete_all_associations
    inbox.destroy
    trashbox.destroy
    columns(true).each(&:destroy)
  end
  
  
end
