ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'
  
  map.resources   :support_requests
  map.resource    :session,     :member => { :jumpin => :get, :forgot_password => :post }
  map.resource    :bookmarklet, :new    => { :nonhtml => :get }
  
  map.resources   :users,       :member     => { :undelete => :get }
  map.resource    :inbox,       :member     => { :bookmarks => :get }
  map.resource    :trashbox,    :member     => { :bookmarks => :get }
  map.resources   :columns,     :collection => { :sort => :put }
  map.resources   :boxes,       :collection => { :sort => :put }, 
                                :member     => { :toggle_collapse => :put, :colorize => :put, :change_title => :put, :bookmarks => :put }
  map.resources   :bookmarks,   :collection => { :sort => :put },
                                :member     => { :trash => :put }
  
  map.myhome    'myhome', :controller => 'users', :action => 'home', :conditions => {:method => :get}
  map.site      ':page',  :controller => 'site',  :action => 'show'
  
  
end

