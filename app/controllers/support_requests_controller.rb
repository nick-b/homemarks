class SupportRequestsController < ApplicationController
  
  skip_before_filter  :login_required
  
  
  def new
    @support_request = SupportRequest.new
  end
  
  def create
    @support_request = SupportRequest.new(params[:support_request])
    @support_request.user = current_user
    @support_request.save!
    head :ok
  end
  
  
end
