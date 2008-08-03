ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'
  
  map.resources   :support_requests
  map.resource    :session,   :member => { :jumpin => :get, :forgot_password => :post }
  
  map.resources   :users,     :member => { :undelete => :get }
  map.resource    :inbox,     :member => { :bookmarks => :get }
  map.resource    :trashbox,  :member => { :bookmarks => :get }
  map.resources   :columns,   :collection => { :sort => :put }
  map.resources   :boxes,     :collection => { :sort => :put }, 
                              :member     => { :toggle_collapse => :put, :colorize => :put, :change_title => :put, :bookmarks => :put }
  map.resources   :bookmarks, :collection => { :sort => :put },
                              :member     => { :trash => :put }
  
  map.myhome    'myhome', :controller => 'users', :action => 'home', :conditions => {:method => :get}
  map.site      ':page',  :controller => 'site',  :action => 'show'
  
  # # Name routes for actions on bookmarklets controller.
  # map.setup_form  'bookmarklet/setup/:uuid', :controller => 'bookmarklet', :action => 'setup', :requirements => { :uuid => /[a-z0-9]{32}/ }
  # map.save_link   'bookmarklet/save/:uuid', :controller => 'bookmarklet', :action => 'save', :requirements => { :uuid => /[a-z0-9]{32}/ }
  # map.nonhtml     'bookmarklet/nonhtml/:uuid', :controller => 'bookmarklet', :action => 'nonhtml', :requirements => { :uuid => /[a-z0-9]{32}/ }
    
  
end
