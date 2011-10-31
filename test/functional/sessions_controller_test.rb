require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @bob = users(:bob)
  end


  context 'While testing the new action' do

    should 'get the page with success' do
      get :new
      assert_site_page_success :title => 'My HomeMarks Login'
    end

    should 'show have a login form and a forgot password form' do
      get :new
      assert_select '#login_area' do
        assert_select '#login_form'
        assert_select 'input#email'
        assert_select 'input#password'
        assert_select 'input[type=submit]'
      end
      assert_select '#forgotpw_area' do
        assert_select '#forgotpw_form'
        assert_select 'input#email'
        assert_select 'input[type=submit]'
      end
    end

    should 'not show the forgot password area' do
      get :new
      assert_element_hidden '#forgotpw_area'
    end

  end

  context 'While testing the create action' do

    should 'login as bob' do
      xhr_login
      assert_good_login
      assert_response :ok
    end

    should 'fail login as bob' do
      xhr_login(:email => '', :password => '')
      assert_no_current_user
      assert_json_response
      assert_response :unauthorized, 'Should be a simple head Unauthorized'
      ['Email is blank','Password is blank'].each do |error|
        assert_match error, @response.body
      end
    end

  end

  context 'While testing the destroy action' do

    setup { login_as(:bob) }

    should 'logout' do
      delete :destroy
      assert_logged_out
    end

  end


  context 'While testing the jumpin action' do

    should 'login with token' do
      get :jumpin, {:token => @bob.security_token}
      assert_good_login
      assert_redirected_to myhome_url
    end

    should 'fail login when token is bad' do
      get :jumpin, {:token => '1234'}
      assert_no_current_user
      assert_redirected_to root_url
    end

  end

  context 'While testing the forgot_password action' do

    should 'find user, update token, and deliver email' do
      User.expects(:find_by_email).with(@bob.email).once.returns(@bob)
      @bob.expects(:generate_security_token).with(true).once
      UserMailer.expects(:deliver_forgot_password).with(@bob).once
      xhr :post, :forgot_password, {:email => @bob.email}
      assert_response :ok
    end

    should 'find user without stubed expectations above' do
      xhr :post, :forgot_password, {:email => @bob.email}
      assert_response :ok
    end

    should 'fail when email is not found' do
      User.any_instance.expects(:generate_security_token).never
      UserMailer.expects(:deliver_forgot_password).never
      xhr :post, :forgot_password, {:email => 'will@notexist.com'}
      assert_response :not_found
    end


  end





  protected

  def xhr_login(overrides={})
    xhr :post, :create, default_params(overrides)
  end

  def default_params(overrides={})
    {:email => @bob.email, :password => 'test'}.merge!(overrides)
  end

  def assert_good_login
    assert_current_user
    assert_equal session[:user_id], @bob.id, 'Bobs ID should be in the session'
  end


end

