module AuthenticatedTestHelper
  
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
  end

  def authorize_as(user, password='test')
    @request.env["HTTP_AUTHORIZATION"] = user ? 
      ActionController::HttpAuthentication::Basic.encode_credentials(users(user).email,password) : nil
  end
  
  def create_user(attributes={})
    returning user = User.new do
      user.email    = 'user@test.com'
      user.password = 'test'
      user.password_confirmation = 'test'
      user.attributes = attributes
      user.save
    end
  end
  
end
