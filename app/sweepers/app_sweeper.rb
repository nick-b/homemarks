class AppSweeper < ActionController::Caching::Sweeper
  
  observe Bookmark, Box, Inbox, Trashbox, Column
  
  def after_save(record)
    expire_user_home_cache
  end
  
end

