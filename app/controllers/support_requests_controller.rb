class SupportRequestsController < ApplicationController
  
  skip_before_filter  :login_required
  
  # @support = SupportRequest.new
  
  def index
    
  end
  
  def show
    
  end
  
  
  protected
  
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
  
  def any_support_blank?
    return true if params[:support][:email].blank?
    return true if params[:support][:problem].blank?
    return true if params[:support][:details].blank?
    false
  end
  
  
end
