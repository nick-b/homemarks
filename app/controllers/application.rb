class ApplicationController < ActionController::Base
  
  before_filter :login_required, :find_user_object
  layout  'application'
  
  
  protected
  
  include AuthSystem::ControllerMethods
  include CacheMasters::ControllerMethods
  
  def rescue_action(flash_msg, userobj, paramsid='no_params')
    ctl_name = controller_name.camelize
    act_name = action_name
    ip = request.env["REMOTE_ADDR"]
    uri = request.env["REQUEST_URI"]
    logger.error("ERROR: #{ctl_name}Controller##{act_name} - failure where parmas id (#{paramsid.inspect}) for user id (#{userobj.nil? ? 'none_from_bookmarklet' : userobj.id}) using (#{uri}) from (#{ip}).")
    unless (ctl_name=='Bookmarklet')
      flash[:bad] = "#{flash_msg}"
      render(:update) {|page| page.redirect_to(myhome_url)}
    end
  end
  
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

