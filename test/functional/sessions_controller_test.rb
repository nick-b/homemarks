require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  
  context 'While testing the new action' do
    
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
  
  
  
  protected
  
  def assert_login_form
    assert_select '#login_form' do
      assert_select 'input#email'
      assert_select 'input#password'
      assert_select 'input[type=submit]'
    end
  end
  
  def xhr_login(overrides={})
    xhr :post, :create, default_params(overrides)
  end
  
  def default_params(overrides={})
    {:email => @bob.email, :password => 'test'}.merge!(overrides)
  end
  
  def assert_good_login
    assert_current_user
    assert_equal session[:user_id], @bob.id, 'Bobs ID should be in the session'
    assert_equal 'Login Successful!', flash[:good]
  end
  
  
end

