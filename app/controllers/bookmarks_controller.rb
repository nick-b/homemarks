class BookmarksController < ApplicationController
  
  prepend_before_filter :ignore_lost_sortable_requests
  before_filter         :find_bookmark, :except => [ :create ]
  # TODO [DEMO] Controller filters
  # after_filter :expire_user_home_cache, :only => [ :new_in_box, :save_links ]
  # after_filter :expire_correct_fragment, :only => [ :sort, :trash ]
  
  
  def show
    render_json_data(@bookmark)
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
    @bookmark.trash!
    head :ok
  end
  
  
  
  private
  
  def find_bookmark
    @bookmark = case params[:type]
    when 'Box' : current_user.boxes.bookmark(params[:id])
    when 'Inbox' : current_user.inbox.bookmarks.find(params[:id])
    when 'Trashbox' : current_user.trashbox.bookmarks.find(params[:id])
    end
  end
  
  def owner_change_sort?
    
  end
  
  
end

