class SiteController < ApplicationController
  
  layout 'site'
  skip_before_filter :login_required, :find_user_object
  verify :method => :post, :only => [:request_support], :redirect_to => :index_url
  before_filter :setup_site_instance_vars, :only => [ :index, :help, :issues ]
  
  def index
    @demojumpurl = jumpin_url(:user_id => HmConfig.demo[:id], :token => HmConfig.demo[:token], :redirect => 'myhome')
  end
  
  def help
  end
  
  def issues
  end
  
  def request_support
    if any_support_blank?
      render(:update) {|page| page.complete_support_form('bad')}
    else
      helpme = SupportRequest.new(params[:support])
      find_user_object if !session[:user].blank?
      if @user
        helpme.user_id = @user.id
        helpme.from_user = true
      end
      helpme.save
      render(:update) {|page| page.complete_support_form('good')}
    end
  end
  
  
  protected
  
  def setup_site_instance_vars
    @support = SupportRequest.new
    @email_value = session[:user].blank? ? '' : User.find(session[:user]).email
  end
  
  def any_support_blank?
    return true if params[:support][:email].blank?
    return true if params[:support][:problem].blank?
    return true if params[:support][:details].blank?
    false
  end
  
  
end
