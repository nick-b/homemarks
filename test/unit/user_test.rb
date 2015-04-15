require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  should_have_one  :inbox
  should_have_one  :trashbox
  should_have_many :columns, :support_requests
  should_have_many :boxes, :through => :columns

  def setup
    @user = users(:bob)
  end

  context 'Testing fixture data and factory methods' do

    should 'be able to create a basic user' do
      assert_difference 'User.count' do
        @user = create_user
        assert !@user.new_record?, @user.errors.full_messages.to_sentence
      end
    end

  end

  context 'Creating a user with VALID attributes' do

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

  context 'Creating a user with INVALID attributes' do

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

  context 'Testing class methods' do

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

  context 'Updating attributes for an existing user' do

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

    should 'save record if generate_security_token is passed true' do
      User.any_instance.expects(:save!).once
      @user.generate_security_token(true)
    end

    should 'not save record if generate_security_token is not called with true' do
      User.any_instance.expects(:save!).never
      @user.generate_security_token
    end

    should 'cache dirty changes in custom_changed_cache accessor' do
      old_email = @user.email
      new_email = 'new@test.com'
      assert_nil @user.custom_changed_cache
      @user.update_attributes! :email => new_email
      assert_not_nil @user.custom_changed_cache
      assert_not_nil @user.custom_changed_cache[:email]
      assert_equal [old_email,new_email], @user.custom_changed_cache[:email]
    end

  end

  context 'Testing boxes association extension' do

    setup { @bookmark = bookmarks(:bob_col3_box1_bmark1) }

    should 'find a bookmark using id' do
      found_bookmark = @user.boxes.bookmark(@bookmark.id)
      assert_equal @bookmark, found_bookmark
    end

    should 'raise not found error for other bookmark' do
      bookmark = Bookmark.new :name => 'Foo', :url => 'Bar'
      bookmark.owner_id = 420
      bookmark.owner_type = 'Box'
      bookmark.save!
      assert_raise(ActiveRecord::RecordNotFound) { @user.boxes.bookmark(bookmark.id) }
    end

  end

  context 'Testing box optgroups generation' do

    setup { @optgroups = @user.box_optgroups }

    should 'have optgroup objects for each column plus one inbox' do
      assert_equal @user.columns.count+1, @optgroups.size
    end

    should 'have inbox first' do
      assert_equal 'INBOX', @optgroups.first.col_name
      assert_equal 1, @optgroups.first.boxes.size, 'should be one inbox'
    end

    should 'have box object each to users ordered columns' do
      @user.columns.each_with_index do |column,cindex|
        true_cindex = cindex + 1 # To account for inbox
        assert_equal column.boxes.size, @optgroups[true_cindex].boxes.size
        column.boxes.each_with_index do |box,bindex|
          assert_equal box, @optgroups[true_cindex].boxes[bindex]
        end
      end
    end

  end



end
