class ApplicationController < ActionController::Base
  
  include ERB::Util, AuthenticatedSystem, RenderInvalidRecord, CacheMasters::ControllerMethods
  
  protect_from_forgery
  
  layout        :site_or_application_layout
  session       :session_expires => 120.days.from_now
  cache_sweeper :app_sweeper
  
  before_filter :login_required
  
  
  
  protected
  
  def site_or_application_layout
    controller_name =~ /^(site|support_requests|sessions|users)$/ ? 'site' : 'application'
  end
  
  def render_json_data(data,status=:ok)
    data = data.to_json if data.is_a?(String)
    data = data.to_s if data.is_a?(TrueClass) || data.is_a?(FalseClass)
    render :json => data, :status => status, :content_type => 'application/json'
  end
  
  def internal_sort?
    params[:internal_sort] == 'true'
  end
  
  def gained_sort?
    !params[:gained_id].blank?
  end
  
  def lost_sortable?
    params[:lost_sortable] == 'true'
  end
  
  def ignore_lost_sortable_requests
    head :multi_status if lost_sortable?
  end
  
  
end

