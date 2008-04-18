class UserController < ApplicationController

  skip_before_filter :login_required, :only => [ :forgot_password, :login, :signup ]
  before_filter :control_demo_user, :only => [ :forgot_password, :change_password, :edit, :delete, :restore_deleted ]
  before_filter :nil_demo_account, :only => [ :signup, :login ]
  
  
  def index
    redirect_to myhome_url
  end
  
  def home
    @trashbox = @user.trashbox
    render :layout => 'application'
  end

  def login
    @user = User.new if request.get?
    if request.post?
      u = User.authenticate(params[:user][:email], params[:user][:password])
      if session[:user] = u.blank? ? nil : u.id
        u.logged_in_at = Time.now ; u.save
        flash[:good] = 'Login successful'
        render(:update) {|page| page.redirect_to(myhome_url)}
      else
        render(:update) {|page| page.complete_ajax_form('do_not_enter','login_form')}
      end
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
        flash[:signup] = %(Thank your for signing up for your own HomeMarks page. ) +
                         %(An email has been sent to your <span class="site_blue">#{@user.email}</span> address along with a link to activate your account. ) +
                         %(If you have not done so already, please take a moment to read the HomeMarks documentation.)
        render(:update) {|page| page.redirect_to(help_url)}
      end
    end
  rescue ActiveRecord::RecordInvalid
    render(:update) {|page| page.complete_ajax_form('bad','signup_form')}
  end
  
  def jumpin
    if @user.email = HmConfig.demo[:email]
      @user.token_expiry = Time.now + 30.days ; @user.save
    end
    redirect_to eval(params[:redirect]+'_url')
  end
  
  def logout
    session[:user] = nil
    session[:demo] = nil
    redirect_to index_url
  end
  
  def forgot_password
    return redirect_to(myaccount_url) if user?
    if request.post?
      unless @user = User.find_by_email(params[:user][:email])
        render(:update) { |page| page.complete_forgotpw_form('bad') }
      else
        @user.generate_security_token && @user.save!
        UserNotify.deliver_forgot_password(@user, jumpin_url(:user_id => user.id, :token => @user.security_token, :redirect => 'myaccount'), issues_form_url)
        render(:update) { |page| page.complete_forgotpw_form('good') }
      end
    end
  end
  
  def change_password
    redirect_to myaccount_url if request.get?
    if request.post?
      @user.update_attributes! = params[:user]
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
