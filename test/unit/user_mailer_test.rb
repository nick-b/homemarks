require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  def setup
    @user = users(:bob)
  end
  
  context 'While testing signup' do
    
    setup { @email = UserMailer.create_signup(@user) }
    
    should 'email by UserObserver#after_create' do
      assert_no_emails
      assert_emails(1) { create_user }
    end
    
    should 'build valid email with user' do
      assert_email_to_user_and_from_app_conf
      assert_match 'Welcome to HomeMarks', @email.subject
      assert_jumpin_url
    end

  end
  
  context 'While testing forgot_password' do

    setup { @email = UserMailer.create_forgot_password(@user) }

    should 'build valid email with user' do
      assert_email_to_user_and_from_app_conf
      assert_match 'Forgotten password notification', @email.subject
      assert_match 'change your password', @email.body
      assert_jumpin_url
    end

  end
  
  
  protected
  
  def assert_email_to_user_and_from_app_conf
    assert_equal [@user.email], @email.to
    assert_equal [HmConfig.app[:email_from]], @email.from
  end
  
  def assert_jumpin_url
    assert_match 'homemarks.com/session/jumpin?token=', @email.body
  end
  
  
end
