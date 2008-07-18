module ApplicationHelper  
  
  include CacheMasters::UrlPaths
  
  def title(title)
    content_for(:title) { h(title) }
  end
  
  def site_nav_for(name, nav_url)
    id_filename = "nav_#{name.sub(/\s/,'').underscore}"
    options = {:id => id_filename}
    options.merge!(:method => :delete) if name =~ /logout/i
    img = image_tag "/stylesheets/images/site/#{id_filename}.png", :alt => name, :border => 'none'
    link_to img+name, nav_url, options
  end
  
  def app_nav_for(title, id, nav_url, options={})
    content = content_tag(:span, '', :id => id, :class => 'user_buttons') + options[:xtra_content].to_s
    link_options = {:class => 'tooltipable', :title => title}
    link_options.merge!(:method => :delete) if id =~ /button_logout/
    link_to(content, nav_url, link_options)
  end
  
  def auth_params_js_var
    unless RAILS_ENV == 'test'
      %|var authParams = $H({#{request_forgery_protection_token}:#{form_authenticity_token.inspect}});|
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def create_bookmark_sortables
    current_user.boxes.each do |box|
      page.create_bookmark_sortables_code(box)
    end
  end
  
  def create_bookmark_sortables_code(box)
    sortable_id = case box
                  when Box : "boxid_list_#{box.id}"
                  when Inbox : 'inbox_list'
                  when Trashbox : 'trashbox_list'
                  end
    page.sortable sortable_id,
                  :accept => 'dragable_bmarks',
                  :handle => 'bmrk_handle',
                  :containment => current_user.box_containment_array,
                  :constraint => false,
                  :dropOnEmpty => true,
                  :url => { :controller => 'bookmark', :action => 'sort' },
                  :before => 'globalLoadingBehavior()',
                  :with => 'findDroppedBookmarkInfo(this)'
  end
  
  def link_to_remote_for_actionarea_inbox
    link_to_remote( content_tag('span', '', :id => 'legend_inbox' ), 
                   {:url => '',
                    :condition => 'isActionAreaDisplayed(this)',
                    :before => "loadingActionArea(this)"},
                    :id => 'legend_inbox_link')
  end
  
  def link_to_remote_for_actionarea_trashbox
    link_to_remote( content_tag('span', '', :id => 'legend_trash' ), 
                   {:url => '',
                    :condition => 'isActionAreaDisplayed(this)',
                    :before => "loadingActionArea(this)"},
                    :id => 'legend_trash_link')
  end
  
  def complete_action_area(box_list)
    page['fieldset_progress_wrap'].visual_effect :blind_up, { :duration => 0.35 }
    page[box_list].visual_effect :blind_down, { :duration => 0.35 }
  end
  
  def update_new_trashboxmark_ui_elements_and_message
    page.<< "$('trashcan').classNames().set('trash_full'); showOrHideEmptyTrashBox();"
  end
  
  def remove_all_trashboxmark_ui_elements_and_message(trashempty)
    page.<< "$('trashcan').classNames().set('trash_empty'); showOrHideEmptyTrashBox();" if trashempty
  end
  
  def empty_trash_function
    remote_function( :url => '',
                     :confirm => 'Are you sure? This will permanently delete all bookmarks in your trash.' )
  end
  

  
  
  
  def render_bookmarklet
    js = render :partial => 'bookmarklet/bookmarklet'
    js.gsub!('<script>','')
    js.gsub!('</script>','')
    js.gsub!(/ {2,}/,'')
    js.gsub!(/\n/,'')
    js.gsub!(/ /,'%20')
    js
  end
  
  def render_bookmarklet_save_button
    js = render :partial => 'bookmarklet/add_button'
    js.gsub!('<script>','')
    js.gsub!('</script>','')
    js.gsub!(/ {2,}/,'')
    js.gsub!(/\n/,'')
    js
  end
  

  
  
end
