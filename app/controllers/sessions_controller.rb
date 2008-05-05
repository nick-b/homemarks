class SessionsController < ApplicationController
  
  helper SiteHelper
  
  filter_parameter_logging :password
  skip_before_filter :login_required, :except => [ :destroy ]
  
  
  def new
    render
  end
  
  def create
    self.current_user = User.authenticate(params[:email], params[:password])
    respond_to do |format|
      if logged_in?
        flash[:good] = 'Login successful'
        format.html { redirect_to myhome_url }
        format.js   { head :ok }
      else
        format.html { render :action => 'new' }
        format.js   { render :json => login_failures, :status => :unauthorized, :content_type => 'application/json' }
      end
    end
  end
  
  def destroy
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  
  protected
  
  def login_failures
    login_failed_message = "Login failed. Please double check what you entered. If you still have problems, use the forgot password button."
    returning messages = [] do
      messages << "Email is blank" if params[:email].blank?
      messages << "Password is blank" if params[:password].blank?
      messages << login_failed_message if messages.blank?
    end
  end
  
  
end
