module AuthenticatedSystem
  
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end
  
  protected

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
  end

  def current_user=(new_user)
    session[:user_id] = (new_user && new_user.respond_to?(:crypted_password)) ? new_user.id : nil
    @current_user = new_user || false
  end

  def authorized?
    logged_in?
  end

  def login_required
    authorized? || access_denied
  end
  
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to new_session_path
      end
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def login_from_basic_auth
    authenticate_with_http_basic do |username, password|
      self.current_user = User.authenticate(username, password)
    end
  end

  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
      self.current_user = user
    end
  end
  

end
