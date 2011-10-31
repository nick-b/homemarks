class InboxesController < ApplicationController

  def bookmarks
    render_json_data(current_user.inbox.bookmarks)
  end


end
