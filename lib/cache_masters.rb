
module CacheMasters
  
  module UrlPaths
    
    def user_home_cache
      "/user/#{current_user.id}/home"
    end
    
    def user_inbox_cache
      "/user/#{current_user.id}/inbox"
    end
    
    def user_trashbox_cache
      "/user/#{current_user.id}/trashbox"
    end
    
  end
  
  module ControllerMethods
    
    include CacheMasters::UrlPaths

    def user_home_cache?
      read_fragment(user_home_cache)
    end
    def expire_user_home_cache
      expire_fragment(user_home_cache)
    end
    
    def user_inbox_cache?
      read_fragment(user_inbox_cache)
    end
    def expire_user_inbox_cache
      expire_fragment(user_inbox_cache)
    end
    
    def user_trashbox_cache?
      read_fragment(user_trashbox_cache)
    end
    def expire_user_trashbox_cache
      expire_fragment(user_trashbox_cache)
    end
    
    def expire_action_boxes
      expire_fragment(user_inbox_cache)
      expire_fragment(user_trashbox_cache)
    end
    def expire_all
      expire_fragment(user_home_cache)
      expire_fragment(user_inbox_cache)
      expire_fragment(user_trashbox_cache)
    end
    
  end  
  
end



