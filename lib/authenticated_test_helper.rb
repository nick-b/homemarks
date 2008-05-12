module AuthenticatedTestHelper
  
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
  end

  def authorize_as(user, password='test')
    @request.env["HTTP_AUTHORIZATION"] = user ? 
      ActionController::HttpAuthentication::Basic.encode_credentials(users(user).email,password) : nil
  end
  
  def create_user(overrides={})
    attributes = {:email => 'user@test.com', :password => 'test', :password_confirmation => 'test'}.merge!(overrides)
    User.create(attributes)
  end
  
  def assert_current_user
    assert_not_nil session[:user_id], 'The session[:user_id] should not be nil'
    assert_instance_of User, assigns(:current_user)
  end
  
  def assert_no_current_user
    assert_nil session[:user_id], 'The session[:user_id] should be nil'
    assert_contains [false,nil], assigns(:current_user)
  end
  
  
end
