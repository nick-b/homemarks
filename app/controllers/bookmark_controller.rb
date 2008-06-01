class BookmarkController < ApplicationController
  
  verify :xhr => true, :add_flash => {:bad => 'Invalid request method.'}, :redirect_to => :myhome_url
  prepend_before_filter :do_nothing_on_lost_bookmark_sort
  after_filter :expire_user_home_cache, :only => [ :new_in_box, :save_links ]
  after_filter :expire_correct_fragment, :only => [ :sort, :trash ]
  
  
  def new_in_box
    # TODO: Revisit this quick code and UI needs, double check after_filter cache expire.
    @box = @user.boxes.find(params[:id])
    @box.bookmarks.create
    render :update do |page|
      page.replace_html 'bookmark_edit_table', :partial => 'bookmark_row', :collection => @box.bookmarks
    end
  end
  
  
  def edit_links
    @box = @user.boxes.find(params[:id])
    render :update do |page|
      page.replace_html 'modal_html_rel-wrapper', :partial => 'edit_links'
      page.hide :modal_progress
      page.visual_effect :slide_down, 'modal_html_rel-wrapper', :duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@box.id}"}
    end
  end
  
  def save_links    
    @box = @user.boxes.find(params[:id])
    @boomarks = @box.bookmarks
    Bookmark.transaction do
      @boomarks.each do |bookmark|
        bookmark.name = params[:bookmark_row][bookmark.id.to_s][:name]
        bookmark.url = params[:bookmark_row][bookmark.id.to_s][:url]
        bookmark.save!
      end
    end
    render :update do |page|
      page.replace_html "boxid_list_#{@box.id}", :partial => 'bookmark_list', :locals => {:box => @box, :box_type => 'box'}
      page.create_bookmark_sortables_code(@user,@box)
      page.<< "destroyModalMask(#{@box.id});"
      page.visual_effect :pulsate, "boxid_list_#{@box.id}", :duration => 1.0, :queue => {:position => 'end', :scope => "boxid_#{@box.id}"}
      page.<< "Event.observe(document, 'keypress', actionAreaHelper);"
    end
  end
  
  
  def sort
    find_dopped_on_box
    find_sorted_bookmark
    Bookmark.transaction do
      if internal_sort?
        @bookmark.insert_at(params[:bmark_position])
      else
        if @box_sort
          convert_bookmark if !@boxmark
          @bookmark.insert_at_new_scope_and_position(@box.id, params[:bmark_position]) if @boxmark
        elsif @inbox_sort || @trashbox_sort
          convert_bookmark
        end
      end
    end
    render :update do |page|
      if @new_bookmark
        page.replace "#{@bookmark_scope}bmark_#{params[:bmark_id]}", :inline => page.bookmark_list_item, :locals => {:bmark => @new_bookmark, :box_type => @new_bookmark_scope}
        page.create_bookmark_sortables_code(@user,@box)
      end
      page.update_new_trashboxmark_ui_elements_and_message if @trashbox_sort
    end
  end
  
  
  def trash
    find_deleted_bookmark
    if @trashboxmark
      @bookmark.destroy
      @trashempty = @user.trashbox.empty?
    else
      Trashboxmark.transaction do
        @box = @user.trashbox
        convert_bookmark
      end
    end
    render :update do |page| 
      if @trashboxmark
        page.remove_all_trashboxmark_ui_elements_and_message(@trashempty)
      else
        page.insert_html :top, "trashbox_list", :inline => page.bookmark_list_item, :locals => {:bmark => @new_bookmark, :box_type => @new_bookmark_scope}
        page.create_bookmark_sortables_code(@user,@box)
        page.update_new_trashboxmark_ui_elements_and_message
      end
    end
  end
  
  
  
  private
  
  def internal_sort?
    return true if (params[:internal_sort] == 'true')
    return false if (params[:internal_sort] == 'false')
  end
  
  def lost_bookmark?
    return true if (params[:lost_bmark] == 'true')
    return false if (params[:lost_bmark] == 'false')
  end
  
  def find_sorted_bookmark
    @bookmark = Bookmark.find_via_users_boxes(@user,params[:bmark_id]) if (params[:bmark_scope] == 'box')
    @bookmark = @user.inbox.bookmarks.find(params[:bmark_id]) if (params[:bmark_scope] == 'inbox')
    @bookmark = @user.trashbox.bookmarks.find(params[:bmark_id]) if (params[:bmark_scope] == 'trashbox')
    find_bookmark_scope
  end
  
  def find_deleted_bookmark
    bmark = params[:id].split('_')
    @bookmark = Bookmark.find_via_users_boxes(@user,bmark[1]) if (bmark[0] == 'boxbmark')
    @bookmark = @user.inbox.bookmarks.find(bmark[1]) if (bmark[0] == 'inboxbmark')
    @bookmark = @user.trashbox.bookmarks.find(bmark[1]) if (bmark[0] == 'trashboxbmark')
    find_bookmark_scope
  end
  
  def find_bookmark_scope
    @bookmark_scope = case @bookmark ; when Bookmark : 'box' ; when Inboxmark : 'inbox' ; when Trashboxmark : 'trashbox' ; end
    is_a_boxmark? ; is_a_inboxmark? ; is_a_trashboxmark?
  end
  
  def is_a_boxmark? ; @boxmark = (@bookmark_scope == 'box') ? true : false ; end
  def is_a_inboxmark? ; @inboxmark = (@bookmark_scope == 'inbox') ? true : false ; end
  def is_a_trashboxmark? ; @trashboxmark = (@bookmark_scope == 'trashbox') ? true : false ; end
  
  def find_dopped_on_box
    @box = @user.boxes.find(params[:sortable_id]) if (params[:box_type]=='box')
    @box = @user.inbox if (params[:box_type]=='inbox')
    @box = @user.trashbox if (params[:box_type]=='trashbox')
    box_sort? ; inbox_sort? ; trashbox_sort?
  end
  
  def box_sort? ; @box_sort = (params[:box_type]=='box') ? true : false ; end
  def inbox_sort? ; @inbox_sort = (params[:box_type]=='inbox') ? true : false ; end
  def trashbox_sort? ; @trashbox_sort = (params[:box_type]=='trashbox') ? true : false ; end
  
  def convert_bookmark
    @new_bookmark = @box.bookmarks.build(@bookmark.attributes.reject{|k,v|k=="#{@bookmark_scope}_id"})
    @new_bookmark.created_at = @bookmark.created_at
    @new_bookmark.visited_at = @bookmark.visited_at
    @new_bookmark.save!
    @bookmark.destroy
    @new_bookmark.insert_at(params[:bmark_position]) if params[:bmark_position]
    find_new_bookmark_scope
  end
  
  def find_new_bookmark_scope
    @new_bookmark_scope = case @new_bookmark ; when Bookmark : 'box' ; when Inboxmark : 'inbox' ; when Trashboxmark : 'trashbox' ; end
  end
  
  def do_nothing_on_lost_bookmark_sort
    if (params[:action] == 'sort') and lost_bookmark?
      render :nothing => true
    end
  end
  
  def expire_correct_fragment
    return if (params[:action] == 'sort') and lost_bookmark?
    if (params[:action] == 'sort')
      expire_by_box_type(params[:box_type]) 
      expire_by_box_type(params[:bmark_scope]) if !internal_sort?
    elsif (params[:action] == 'trash')
      expire_by_box_type(@bookmark_scope) if !@trashboxmark
      expire_user_trashbox_cache
    end
  end
  
  
  
end
