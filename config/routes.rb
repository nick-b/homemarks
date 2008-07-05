ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'
  
  map.resources   :support_requests
  map.resource    :session,   :member => { :jumpin => :get, :forgot_password => :post }
  
  map.resources   :users,     :member => { :undelete => :get }
  map.resource    :inbox
  map.resource    :trashbox
  map.resources   :columns,   :collection => { :sort => :put }
  map.resources   :boxes,     :collection => { :sort => :put }, 
                              :member     => { :toggle_collapse => :put, :colorize => :put, :change_title => :put }
  map.resources   :bookmarks, :collection => { :sort => :put, :bookmark => :put },
                              :member     => { :foo => :put }
  
  map.myhome    'myhome', :controller => 'users', :action => 'home', :conditions => {:method => :get}
  map.site      ':page',  :controller => 'site',  :action => 'show'
  
  # # Named routes for action area stuff.
  # map.show_inbox      'actionarea/inbox', :controller => 'action_area', :action => 'inbox'
  # map.show_trashbox   'actionarea/trashbox', :controller => 'action_area', :action => 'trashbox'
  # map.empty_trash     'actionarea/empty_trash', :controller => 'action_area', :action => 'empty_trash'
  #   
  # # Named routes for actions on bookmarks.
  # map.edit_links  'box/edit_links/:id', :controller => 'bookmark', :action => 'edit_links'
  # map.save_links  'box/save_links/:id', :controller => 'bookmark', :action => 'save_links'
  # map.new_in_box  'bookmark/new_in_box/:id', :controller => 'bookmark', :action => 'new_in_box'
  # map.trash       'bookmark/trash', :controller => 'bookmark', :action => 'trash'
  # 
  # # Name routes for actions on bookmarklets controller.
  # map.setup_form  'bookmarklet/setup/:uuid', :controller => 'bookmarklet', :action => 'setup', :requirements => { :uuid => /[a-z0-9]{32}/ }
  # map.save_link   'bookmarklet/save/:uuid', :controller => 'bookmarklet', :action => 'save', :requirements => { :uuid => /[a-z0-9]{32}/ }
  # map.nonhtml     'bookmarklet/nonhtml/:uuid', :controller => 'bookmarklet', :action => 'nonhtml', :requirements => { :uuid => /[a-z0-9]{32}/ }
    
  
end
