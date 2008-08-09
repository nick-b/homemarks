class BookmarkletsController < ApplicationController

  skip_before_filter :login_required
  
  before_filter :redirect_if_no_referer,   :except => [ :create ]
  before_filter :redirect_if_self_referal, :only   => [ :new ]
  before_filter :auth_by_uuid
  
  
  def new
    render :update do |page|
      page << "Builder.dump();"
      page << "HomeMarksModal = new HomeMarksModalClass();"
      page.replace_html 'modal_content', :partial => 'form'
      page << "HomeMarksModal.showBookmarkModal();"
    end
  end
  
  def nonhtml
    @bookmark_url = request.referer
    render :partial => 'form', :layout => 'bookmarklet'
  end
  
  def bookmark
    @nonhtml = params[:url] != 'from_referer'
    @bmurl = @nonhtml ? params[:url] : request.referer
    @box = params[:box_id] == 'inbox' ? current_user.inbox : current_user.boxes.find(params[:box_id])
    @box.bookmarks.create :name => params[:name], :url => @bmurl
    render :update do |page|
      page << "HomeMarksModal.hide()"
      page.delay(1) { page.remove('modalmask'); page.remove('modal_html_ap-wrapper') }
      page.redirect_to(@bmurl) if @nonhtml
    end
  end
  
  
  
  protected
  
  def redirect_if_no_referer
    redirect_to root_url unless request.referer
  end
  
  def redirect_if_self_referal
    if request.referer.include?(HmConfig.app[:host])
      render(:update) { |page| page.redirect_to site_url('help',:anchor => 'homemarklet') } 
    end
  end
  
  def auth_by_uuid
    unless self.current_user = User.find_by_uuid(params[:uuid])
      if action_name =~ /nonhtml|create/
        redirect_to root_url
      else
        render(:update) { |page| page.redirect_to root_url } 
      end
    end
  end
  
  
end
