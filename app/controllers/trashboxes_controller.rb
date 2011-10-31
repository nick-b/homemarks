class TrashboxesController < ApplicationController

  def bookmarks
    render_json_data(current_user.trashbox.bookmarks)
  end

  def destroy
    current_user.trashbox.bookmarks.clear
    head :ok
  end


end
