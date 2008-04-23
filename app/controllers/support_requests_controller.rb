class SupportRequestsController < ApplicationController
  
  skip_before_filter  :login_required
  

  def new
    @support_request = SupportRequest.new
  end

  def create
    @support_request = SupportRequest.new(params[:support_request])
    respond_to do |format|
      if @support_request.save
        flash[:good] = 'Support request was successfully created.'
        format.html { redirect_to(@support_request) }
      else
        format.html { render :action => "new" }
      end
    end
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
