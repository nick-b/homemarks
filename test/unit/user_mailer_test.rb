require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = users(:bob)
    @deliveries = ActionMailer::Base.deliveries
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

  context 'While testing change_account' do

    should 'send 2 emails when user changes email' do
      assert_no_emails
      old_email = @user.email
      new_email = 'new@test.com'
      assert_emails(2) { @user.update_attributes! :email => new_email }
      assert_contains [old_email,new_email], @deliveries[0].to.to_s
      assert_contains [old_email,new_email], @deliveries[1].to.to_s
    end

  end

  context 'While testing the pending_delete' do

    should 'send an email when User#delete! is called' do
      assert_no_emails
      assert_emails(1) { @user.delete! }
      @email = @deliveries.first
      assert_match 'Delete account notification', @email.subject
      assert_match 'marked your account for deletion', @email.body
      assert_recover_url
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

  def assert_recover_url
    assert_match "homemarks.com/users/#{@user.id}/undelete?token=#{@user.security_token}", @email.body
  end


end
