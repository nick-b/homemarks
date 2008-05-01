require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  
  should_have_one  :inbox
  should_have_one  :trashbox
  should_have_many :columns, :support_requests
  should_have_many :boxes, :through => :columns
  

  context 'While testing helpers' do

    should 'be able to create a basic user' do
      assert_difference 'User.count' do
        @user = create_user
        assert !@user.new_record?, @user.errors.full_messages.to_sentence
      end
    end

  end
  
  context 'While creating a user with VALID attributes' do
    
    setup do
      @user = create_user
    end
    
    should 'have an standard boxes created' do
      assert_instance_of Inbox, @user.inbox
      assert_instance_of Trashbox, @user.trashbox
    end
    
    should 'have a security token and expiry set 1 day from now' do
      delta = 1.day.from_now.to_i - @user.token_expiry.to_i
      assert delta < 10 , "Delta in user token_expiry is #{delta}"
      assert_equal 40, @user.security_token.length
    end
    
    should 'have a salt and crypted_password attribute' do
      assert_equal 40, @user.salt.length
      assert_equal 40, @user.crypted_password.length
    end
    
    should 'have a UUID set' do
      assert_equal 32, @user.uuid.length
    end
    
    should 'not be deleted' do
      assert !@user.deleted
    end
    
    should 'not be verified until authenticated by token' do
      assert !@user.verified?
      assert @user = User.authenticate_by_token(@user.security_token)
      assert @user.verified?
    end
    
  end
  
  context 'While creating a user with INVALID attributes' do

    should 'require a valid email' do
      user = create_user :email => 'foo.com'
      assert_match 'invalid', user.errors.on(:email)
    end
    
    should 'require a valid password and confirmation' do
      user = create_user :password => ''
      ['blank','too short','confirmation'].each do |error_msg|
        assert_match error_msg, user.errors.on(:password).to_sentence
      end
    end

  end
  
  context 'While testing class methods' do
    
    setup do
      @user = users(:bob)
    end
    
    should 'be able to find conflicting emails' do
      email = 'email@exists.com'
      create_user :email => email
      assert User.email_exists?(email), "should have found #{email}"
    end
    
    should 'consistently encrypt password with known salt' do
      crypted_password = User.encrypt('test',@user.salt)
      assert_equal crypted_password, @user.crypted_password
    end
    
    should 'be able to authenticate and return user' do
      authed_user = User.authenticate @user.email, 'test'
      assert_equal @user, authed_user
    end
    
    should 'be able to authenticate with token and return user' do
      authed_user = User.authenticate_by_token(@user.security_token)
      assert_equal @user, authed_user
    end

  end
  
  context 'While updating attributes for an existing user' do

    setup do
      @user = users(:bob)
    end

    should 'reset password' do
      @user.update_attributes(:password => 'new_password', :password_confirmation => 'new_password')
      assert_equal @user, User.authenticate(@user.email,'new_password')
    end
    
    should 'do all the right things when deleted' do
      old_token = @user.security_token
      assert @user.delete!
      assert @user.deleted?
      assert !@user.verified?
      assert @user.delete_after >= (HmConfig.app[:delayed_delete_days].days.from_now - 3.seconds)
      assert @user.security_token != old_token
    end
    
    should 'not allow a deleted user to log in' do
      assert @user.delete!
      assert_nil User.authenticate(@user.email,'test')
    end
    
    should 'allow a deleted user to authenticate by token' do
      assert @user.delete!
      assert @auth_user = User.authenticate_by_token(@user.security_token)
      assert_equal @user, @auth_user
      assert !@auth_user.deleted?
      assert @auth_user.verified?
    end
    
  end
  
  
    
  
end
