class UsersController < ApplicationController

  filter_parameter_logging :password

  skip_before_filter  :login_required,     :only => [ :new, :create ]
  before_filter       :redirect_logged_in, :only => [ :new, :create, :undelete ]


  def new
    @user = User.new
  end

  def create
    User.create!(params[:user])
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

  def undelete
    flash[:good] = 'Welcome back :)'
    redirect_to myhome_url
  end

  def home
    render :layout => 'application'
  end


end
