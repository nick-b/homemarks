class UsersController < ApplicationController
  
  helper SiteHelper
  filter_parameter_logging :password
  
  skip_before_filter  :login_required,     :only => [ :new, :create ]
  before_filter       :redirect_logged_in, :only => [ :new, :create ]
  
  # before_filter      :control_demo_user, :only => [ :forgot_password, :change_password, :edit, :delete, :restore_deleted ]
  # before_filter      :nil_demo_account,  :only => [ :signup, :login ]
  
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create!(params[:user])
    head :ok
  end
  
  def edit
    @user = current_user
  end
  
  def update
    current_user.update_attributes! params[:user]
    head :ok
  end
  
  def destroy
    current_user.delete!
    logout
    flash[:good] = "You account has been marked for deletion!"
  end
  
  # def home
  #   @trashbox = @user.trashbox
  #   render :layout => 'application'
  # end
  # 
  # def undelete
  #   @user.deleted = false
  #   if @user.save
  #     flash[:good] = "Welcome back :)"
  #     redirect_to myhome_url
  #   else
  #     redirect_to issues_form_url
  #   end
  # end
  
  
  protected
  

  # # FIXME: Put in some admin namespace
  # def destroy(user)
  #   UserNotify.deliver_delete(user, issues_form_url)
  #   flash[:good] = "The account for #{user['login']} was successfully deleted."
  #   user.destroy()
  # end
  # 
  # def email_demo?
  #   params[:user][:email] == HmConfig.demo[:email]
  # end
  
  
  
end
