class UsersController < ApplicationController
  
  helper SiteHelper
  
  skip_before_filter :login_required,    :only => [ :new, :create ]
  before_filter      :control_demo_user, :only => [ :forgot_password, :change_password, :edit, :delete, :restore_deleted ]
  before_filter      :nil_demo_account,  :only => [ :signup, :login ]
  
  
  def new
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    # Protects against session fixation attacks, wreaks havoc with request forgery protection. Uncomment at your own risk.
    # reset_session
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def signup
    if request.get?
      return redirect_to(myhome_url) if user?
      @user = User.new 
    end
    if request.post?
      if User.email_exists?(params[:user][:email])
        render(:update) {|page| page.redirect_to(forgot_password_url(:email => params[:user][:email]))}
      else
        @user = User.create!(params[:user])
        UserNotify.deliver_signup(@user, jumpin_url(:user_id => @user.id, :token => @user.security_token, :redirect => 'myhome'), issues_form_url)
        flash[:signup] = @user.email
        render(:update) {|page| page.redirect_to(help_url)}
      end
    end
  rescue ActiveRecord::RecordInvalid
    render(:update) {|page| page.complete_ajax_form('bad','signup_form')}
  end
  
  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end
  
  
  
  
  def home
    @trashbox = @user.trashbox
    render :layout => 'application'
  end
  
  
  
  def jumpin
    if @user.email = HmConfig.demo[:email]
      @user.token_expiry = Time.now + 30.days ; @user.save
    end
    redirect_to eval(params[:redirect]+'_url')
  end
  
  def change_password
    redirect_to myaccount_url if request.get?
    if request.post?
      @user.update_attributes! params[:user]
      send_account_changed_notification(@user)
      flash[:good] = 'Password changed.'
      render(:update) {|page| page.redirect_to(myhome_url)}
    end
  rescue ActiveRecord::RecordInvalid
    render(:update) {|page| page.complete_ajax_form('bad','mypassword_form','mypassword_loading')}
  end

  def edit
    if request.post?
      send_account_changed_notification(@user, @user.email)
      send_account_changed_notification(@user, params[:user][:email])
      @user.email = params[:user][:email] ; @user.save!
      flash[:good] = 'Email address updated.'
      render(:update) {|page| page.redirect_to(myhome_url)}
    end
  rescue ActiveRecord::RecordInvalid
    render(:update) {|page| page.complete_ajax_form('bad','myemail_form','myemail_loading')}
  end
  
  def delete
    redirect_to index_url if request.get?
    if request.post?
      token = @user.delete!
      UserNotify.deliver_pending_delete(@user, recover_url(:user_id => @user.id, :token => token), issues_form_url)
      logout
    end
  end
  
  def restore_deleted
    @user.deleted = false
    if @user.save
      flash[:good] = "Welcome back :)"
      redirect_to myhome_url
    else
      redirect_to issues_form_url
    end
  end
  
  
  protected
  
  def send_account_changed_notification(user, email=nil)
    UserNotify.deliver_change_account(user, issues_form_url, email)
  end
  
  # FIXME: Put in some admin namespace
  def destroy(user)
    UserNotify.deliver_delete(user, issues_form_url)
    flash[:good] = "The account for #{user['login']} was successfully deleted."
    user.destroy()
  end
  
  def email_demo?
    params[:user][:email] == HmConfig.demo[:email]
  end
  
  
  
end
