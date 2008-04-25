class SupportRequestsController < ApplicationController
  
  helper SiteHelper
  skip_before_filter  :login_required
  
  
  def new
    @support_request = SupportRequest.new
  end
  
  def create
    @support_request = SupportRequest.new(params[:support_request])
    @support_request.user = current_user
    @support_request.save!
    respond_to do |format|
      flash[:good] = 'Thanks you for contacting me. I hope to get to your issue soon.'
      redirect_location = logged_in? ? root_url : root_url # FIXME: Add correct user home url.
      format.html { redirect_to redirect_location } 
      format.js   { redirect_to redirect_location }
    end
  end
  
  
end
