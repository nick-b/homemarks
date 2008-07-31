class BookmarksController < ApplicationController
  
  prepend_before_filter :ignore_lost_sortable_requests
  before_filter         :find_bookmark, :except => [ :create ]
  # TODO [DEMO] Controller filters
  # after_filter :expire_user_home_cache, :only => [ :new_in_box, :save_links ]
  # after_filter :expire_correct_fragment, :only => [ :sort, :trash ]
  
  
  def show
    render_json_data(@bookmark)
  end
  
  def create
    box = current_user.boxes.find(params[:box_id])
    @bookmark = box.bookmarks.create!(params[:bookmark])
    render_json_data(@bookmark.id)
  end
  
  def sort
    if internal_sort?
      @bookmark.insert_at(params[:position])
    else
      @box = current_user.boxes.find(params[:gained_id])
      @bookmark.insert_at_new_scope_and_position(@box.id, params[:position])
    end
    head :ok
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
  
  def find_bookmark
    @bookmark = case params[:type]
    when 'Box' : current_user.boxes.bookmark(params[:id])
    when 'Inbox' : current_user.inbox.bookmarks.find(params[:id])
    when 'Trashbox' : current_user.trashbox.bookmarks.find(params[:id])
    end
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
    @new_bookmark.save!
    @bookmark.destroy
    @new_bookmark.insert_at(params[:bmark_position]) if params[:bmark_position]
    find_new_bookmark_scope
  end
  
  def find_new_bookmark_scope
    @new_bookmark_scope = case @new_bookmark ; when Bookmark : 'box' ; when Inboxmark : 'inbox' ; when Trashboxmark : 'trashbox' ; end
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
