class ApplicationController < ActionController::Base
  
  include ERB::Util, AuthenticatedSystem, RenderInvalidRecord
  
  protect_from_forgery
  
  layout        :site_or_application_layout
  before_filter :login_required
  
  
  
  protected
  
  def site_or_application_layout
    controller_name =~ /^(site|support_requests|sessions|users)$/ ? 'site' : 'application'
  end
  
  def render_json_data(data,status=:ok)
    render :json => data, :status => status, :content_type => 'application/json'
  end
  
  def internal_sort?
    params[:internal_sort] == 'true'
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
  
  def nil_demo_account
    if session[:demo] == true
      session[:user] = nil
      session[:demo] = nil
    end
  end
  
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

