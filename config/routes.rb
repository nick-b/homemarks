ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'
  
  map.resources :support_requests
  map.resource  :session, :member => { :jumpin => :get, :forgot_password => :post }
  map.resources :users,   :member => { :undelete => :get }
  
  map.resources :columns
  map.resources :boxes
  map.resources :bookmarks
  
  
  map.myhome    'myhome', :controller => 'users', :action => 'home', :method => :get
  map.site      ':page',  :controller => 'site',  :action => 'show'
  
  
  # # Named routes for actions on columns.
  # map.column_new      'column/new/:id', :controller => 'column', :action => 'new'
  # map.column_destroy  'column/destroy/:id', :controller => 'column', :action => 'destroy'
  # 
  # # Named routes for actions on boxes.
  # map.box_new       'box/new/:id', :controller => 'box', :action => 'new'
  # map.box_collapse  'box/collapse/:id', :controller => 'box', :action => 'collapse'
  # map.box_destroy   'box/destroy/:id', :controller => 'box', :action => 'destroy'
  # map.change_color  'box/change_color/:id/:color', :controller => 'box', :action => 'change_color'
  # map.change_title  'box/change_title/:id', :controller => 'box', :action => 'change_title'
  # 
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
