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
      assert_equal [@user.email], @email.to
      assert_match 'Welcome to HomeMarks', @email.subject
      assert_equal [HmConfig.app[:email_from]], @email.from
      assert_match 'homemarks.com/session/jumpin?token=', @email.body
    end

  end
  
  
  
end
