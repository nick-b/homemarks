class TrashboxesController < ApplicationController
  
  def bookmarks
    render_json_data(current_user.trashbox.bookmarks)
  end
  
  
end
