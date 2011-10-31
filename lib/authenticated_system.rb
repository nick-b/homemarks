module AuthenticatedSystem

  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  protected

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_token) unless @current_user == false
  end

  def current_user=(new_user)
    session[:user_id] = (new_user && new_user.respond_to?(:crypted_password)) ? new_user.id : nil
    @current_user = new_user || false
  end

  def logout
    reset_session
    flash[:indif] = "You have been logged out."
    redirect_back_or_default
  end

  def authorized?
    logged_in?
  end

  def login_required
    authorized? || access_denied
  end

  def access_denied
    respond_to do |format|
      format.html { store_location ; redirect_to new_session_url }
      format.js { store_location ; redirect_to new_session_url }
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_logged_in
    if logged_in?
      respond_to do |format|
        format.html { redirect_to myhome_url }
        format.js { redirect_to myhome_url }
      end
      return false
    end
  end

  def redirect_back_or_default
    redirect_to session[:return_to] || root_url
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

  def login_from_token
    authorized_action = controller_name =~ /sessions|users/ && action_name =~ /jumpin|undelete/
    if authorized_action
      self.current_user = User.authenticate_by_token(params[:token])
    end
  end


end
