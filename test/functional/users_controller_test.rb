require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  
  
  context 'While testing the new action' do
    
    should 'get the page with success' do
      get :new
      assert_instance_of User, assigns(:user)
      assert_site_page_success :title => 'HomeMarks Signup'
    end
    
    should 'show the login form' do
      get :new
      assert_login_form
    end
    
    should 'redirect when already logged in' do
      login_as(:bob)
      get :new
      assert_redirected_to myhome_url
    end
    
  end
  
  
  context 'While testing the create action' do
    
    should 'signup' do
      xhr_signup
      assert_good_signup
    end
    
    should 'redirect when already logged in' do
      login_as(:bob)
      xhr_signup
      assert_redirected_to myhome_url
    end
    
    should 'delete auth token' do
      cookies[:auth_token] = 'abcd'
      xhr_signup
      assert_nil cookies[:auth_token]
    end
    
    should 'fail with blank attributes and json body errors' do
      xhr_signup :email => '', :password => '', :password_confirmation => ''
      assert_json_response
      [ "Email can't be blank", "Email is invalid", 
        "Password can't be blank", "Password is too short", "Password confirmation"].each do |error|
        assert_match error, @response.body
      end
    end
    
  end
  
  
  
  protected
  
  def assert_login_form
    assert_select '#signup_form' do
      assert_select 'input#user_email'
      assert_select 'input#user_password'
      assert_select 'input#user_password_confirmation'
      assert_select 'input[type=submit]'
    end
  end
  
  def xhr_signup(overrides={})
    xhr :post, :create, default_params(overrides)
  end
  
  def default_params(overrides={})
    {:user => {:email => 'signup@test.com', :password => 'test', :password_confirmation => 'test'}.merge(overrides)}
  end
    
  def assert_good_signup
    assert_current_user
    assert_response :ok
    assert @response.body.blank?
  end
  
  
end

