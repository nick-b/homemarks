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
      format.html { redirect_to root_url }
      format.js { head :ok }
    end
  end
  
  
end
