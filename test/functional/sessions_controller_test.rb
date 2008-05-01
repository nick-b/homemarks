require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  
  context 'While test new action' do
    
    should 'get the page with success' do
      get :new
      assert_site_page_success :title => 'My HomeMarks Login'
    end
    
    should 'show the login form' do
      get :new
      assert_login_form
    end
    
  end
  
  context 'While testing the create action' do
    
    setup do
      @bob = users(:bob)
    end
    
    context 'with XHR' do

      should 'login as bob' do
        xhr_login_as_bob
        assert_good_login_for_bob
        assert_response :ok, 'Should be a simple head OK'
      end
      
      should 'fail login as bob' do
        xhr_login_as_bob(:password => 'badpw')
        assert_bad_login
        assert_response :unauthorized, 'Should be a simple head Unauthorized'
      end

    end
    
    context 'with HTTP POST' do

      should 'login as bob' do
        post_login_as_bob
        assert_good_login_for_bob
        assert_response :redirect, "Should redirect to user's home"
      end
      
      should 'fail login as bob and render new action' do
        post_login_as_bob(:password => 'badpw')
        assert_bad_login
        assert_response :success
        assert_template('new')
        assert_login_form
      end
      
    end
    
  end
  
  
  protected
  
  def assert_login_form
    assert_select '#login_form' do
      assert_select 'input#email'
      assert_select 'input#password'
      assert_select 'input[type=submit]'
    end
  end
  
  def xhr_login_as_bob(overrides={})
    xhr :post, :create, bobs_params(overrides)
  end
  
  def post_login_as_bob(overrides={})
    post :create, bobs_params(overrides)
  end
  
  def bobs_params(overrides={})
    {:email => @bob.email, :password => 'test'}.merge!(overrides)
  end
  
  def assert_good_login_for_bob
    assert_equal session[:user_id], @bob.id, 'Bobs ID should be in the session'
    assert_good_flash 'Login successful'
  end
  
  def assert_bad_login
    assert_nil session[:user_id]
  end
  
  
end

