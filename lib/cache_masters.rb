
module CacheMasters
  
  module UrlPaths
    
    def user_home_cache
      "/user/#{current_user.id}/home"
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
    
  end  
  
end



