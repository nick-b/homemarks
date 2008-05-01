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
        format.html { redirect_to home_user_url(current_user) }
        format.js   { head :ok }
      else
        format.html { render :action => 'new' }
        format.js   { head :unauthorized }
      end
    end
  end
  
  # def login
  #   if
  #     render(:update) {|page| page.redirect_to(myhome_url)}
  #   else
  #     render(:update) {|page| page.complete_ajax_form('do_not_enter','login_form')}
  #   end
  # end

  def destroy
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end



end
