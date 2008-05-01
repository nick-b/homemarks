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
  
  
end
