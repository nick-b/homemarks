require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @bob = users(:bob)
  end
  
  context 'While testing the new action' do
    
    should 'get the page with success' do
      get :new
      assert_instance_of User, assigns(:user)
      assert_site_page_success :title => 'HomeMarks Signup'
    end
    
    should 'show the login form' do
      get :new
      assert_select '#signup_form' do
        assert_select 'input#user_email'
        assert_select 'input#user_password'
        assert_select 'input#user_password_confirmation'
        assert_select 'input[type=submit]'
      end
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
      assert_response :ok
      assert @response.body.blank?
    end
    
    should 'redirect when already logged in' do
      login_as(:bob)
      xhr_signup
      assert_redirected_to myhome_url
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
  
  context 'While testing the edit action' do
    
    setup { login_as(:bob) }
    
    should 'redirect when not logged in' do
      logout
      get :edit, {:id => @bob.id}
      assert_redirected_to_login
    end
    
    should 'see edit form and delete button along with normal page success' do
      get :edit, {:id => @bob.id}
      assert_site_page_success :title => 'My HomeMarks'
      assert_select '#edit_form' do
        assert_select 'input#user_email[value=?]', @bob.email
        assert_select 'input#user_password'
        assert_select 'input#user_password_confirmation'
        assert_select 'input[type=submit]'
      end
      assert_select 'input[value=?]', 'Delete Account'
    end

  end
  
  context 'While testing the update action' do
    
    setup { login_as(:bob) }
    
    should 'redirect when not logged in' do
      logout
      xhr_update_bob
      assert_redirected_to_login
    end
    
    should 'pass simple email change' do
      new_email = 'new@bob.com'
      xhr_update_bob :email => new_email
      assert_response :ok
      assert_equal new_email, assigns(:current_user).email
    end
    
    should 'pass simple password change' do
      xhr_update_bob :password => 'secret', :password_confirmation => 'secret'
      assert_response :ok
    end
    
    should 'fail with JSON erros when email is blank' do
      xhr_update_bob :email => ''
      assert_json_response
      [ "Email can't be blank", "Email is invalid" ].each do |error|
        assert_match error, @response.body
      end
    end
    
  end
  
  context 'While testing the destroy action' do
    
    setup { login_as(:bob) }
    
    should 'redirect when not logged in' do
      logout
      delete_destroy_bob
      assert_redirected_to_login
    end
    
    should 'mark as deleted and logout' do
      delete_destroy_bob
      assert assigns(:current_user).deleted?
      assert_logged_out
      assert_good_flash 'You account has been marked for deletion'
    end
    
  end
  
    
  
  protected
  
  def xhr_signup(overrides={})
    xhr :post, :create, default_params(overrides)
  end
  
  def xhr_update_bob(overrides={})
    xhr :post, :update, {:id => @bob.id, :user => {:email => @bob.email}.merge(overrides)}
  end
  
  def delete_destroy_bob
    delete :destroy, {:id => @bob.id}
  end
  
  def default_params(overrides={})
    {:user => {:email => 'signup@test.com', :password => 'test', :password_confirmation => 'test'}.merge(overrides)}
  end
  
  
end

