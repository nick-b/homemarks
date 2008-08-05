class BookmarksController < ApplicationController
  
  prepend_before_filter :ignore_lost_sortable_requests
  before_filter         :find_bookmark
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
      type_or_box = to_type == :box ? current_user.boxes.find(params[:gained_id]) : to_type
      @bookmark.to_box(type_or_box,params[:position])
    end
    head :ok
  end
  
  def trash
    @bookmark.trash!
    head :ok
  end
  
  
  
  private
  
  def find_bookmark
    verify_type_params
    id = params[:id]
    @bookmark = type == :box ? current_user.boxes.bookmark(id) : current_user.send(type).bookmarks.find(id)
  end
  
  def verify_type_params
    [:type,:old_type].each do |type|
      tvalue = params[type]
      raise(ArgumentError,"Invalid :#{type} parameter.") if tvalue && !Bookmark::OWNER_TYPES.include?(tvalue)
    end
  end
  
  def type
    type = gained_sort? ? :old_type : :type
    symbolize_type(type)
  end
  
  def to_type
    symbolize_type(:type)
  end
  
  def symbolize_type(type)
    params[type].downcase.to_sym
  end
  
  
end

