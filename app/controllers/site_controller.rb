class SiteController < ApplicationController
  
  PAGES = ['help']
  
  skip_before_filter  :login_required
  before_filter       :ensure_valid_page, :except => :index
  
  
  def index
    # @demojumpurl = jumpin_url(:user_id => HmConfig.demo[:id], :token => HmConfig.demo[:token], :redirect => 'myhome')
  end
  
  def show
    @support_request = SupportRequest.new
    render :template => "site/#{current_page}"
  end
  
  
  protected
  
  def current_page
    params[:page].to_s.downcase
  end
  
  def ensure_valid_page
    unless PAGES.include?(current_page)
      render :nothing => true, :status => 404 and return false
    end
  end
  
  
end
