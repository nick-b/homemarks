class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  
  layout                :site_or_application_layout
  protect_from_forgery  # :secret => 'a9be993c84c9e7e62872dc24a48c0a43'
  before_filter         :login_required
  
  
  
  protected
  
  def site_or_application_layout
    controller_name =~ /^(site|user)$/ ? 'site' : 'application'
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
  
  # FIXME: Include the correct view helper for this.
  def h(s)
    s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
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

