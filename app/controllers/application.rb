class ApplicationController < ActionController::Base
  
  include ERB::Util, AuthenticatedSystem, RenderInvalidRecord
  
  protect_from_forgery
  
  layout        :site_or_application_layout
  session       :session_expires => 120.days.from_now
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
  
  
  
  # FIXME: Add an error mailer, or use exception notification plugin.
  def rescue_action_in_public(exception)
    unless controller_name == 'bookmarklet'
      flash[:bad] = "Sorry, unknown error."
      respond_to do |format|
        format.html { redirect_to myhome_url }
        format.js   { render(:update) { |page| page.redirect_to(myhome_url) } }
      end
    end
  end
  
  # TODO: [DEMO]
  def nil_demo_account
    if session[:demo] == true
      session[:user] = nil
      session[:demo] = nil
    end
  end
  
  # TODO: [DEMO]
  def control_demo_user
    if session[:demo] == true
      if request.get?
        @disable_forms = true
      elsif request.xhr?
        flash[:bad] = "Demo action is disabled"
        render(:update) {|page| page.redirect_to(myhome_url)}
      elsif request.post?
        flash[:bad] = "Demo action is disabled"
        redirect_to myhome_url
      end
    end
  end
  
  
  
end

