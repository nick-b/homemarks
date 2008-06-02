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
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def reorder_then_create_box_sortables(col)
    # Due to some bug, affected column needs to be first in the array before create sortable code fires.
    ucols = current_user.columns
    ucols.slice!(ucols.index(col))
    ucols.unshift(col).each do |sortcol|
      page.create_box_sortables_code(sortcol)
    end
  end
  
  def create_column_sortable
    page.sortable :col_wrapper,
                  :handle => 'ctl_handle',
                  :tag => 'div',
                  :only => 'dragable_columns',
                  :containment => 'col_wrapper',
                  :constraint => false,
                  :dropOnEmpty => true,
                  :url => {:controller => 'column', :action => 'sort'},
                  :before => 'globalLoadingBehavior()',
                  :with => 'findSortedInfo(this)'
  end
  
  def link_to_remote_for_column_delete(col)
    link_to_remote( content_tag('span', '', :class => 'ctl_close'),
                  { :confirm => 'Are you sure? Deleting a COLUMN will also delete all the boxes and bookmarks within it.',
                    :url => '',
                    :before => 'this.blur(); globalLoadingBehavior()' })
  end
  
  
  
  
  def link_to_remote_for_column_add(col)
    link_to_remote( content_tag('span', '', :class => 'ctl_add'),
                  { :url => '',
                    :before => 'this.blur(); globalLoadingBehavior()' })
  end
  
  
  
  
  
  
  
  
  
  
  
  
  

  def create_box_sortables
    current_user.columns.each do |col|
      page.create_box_sortables_code(col)
    end    
  end
  
  def create_box_sortables_code(col)
    page.sortable "col_#{col.id}",
                  :tag => 'div',
                  :only => 'dragable_boxes',
                  :hoverclass => 'column_hover',
                  :accept => 'dragable_boxes',
                  :handle => 'box_handle',
                  :containment => current_user.column_containment_array,
                  :constraint => false,
                  :dropOnEmpty => true,
                  :url => { :controller => 'box', :action => 'sort' },
                  :before => 'globalLoadingBehavior()',
                  :with => 'findDroppedBoxInfo(this)'
  end

  def link_to_remote_for_box_actions(box, action_dir)
    span_class = 'box_action' if action_dir == 'down'
    span_class = 'box_action box_action_down' if action_dir == 'up'
    link_to_remote( content_tag('span', '', :id => "boxid_#{box.id}_action", :class => span_class),
                  { :url => '', :id => box.id, :collapsed => box.collapsed?, # {:controller => 'box', :action => "actions_#{action_dir}"
                    :before => "this.blur(); globalLoadingBehavior(); loadLameActionSpan(#{box.id},'#{action_dir}')" },
                    :id => "boxid_#{box.id}_action_alink" )
  end
  
  def link_to_remote_for_box_title(box)
    link_to_remote( h(box.title),
                  { :url => '', 
                    :before => "this.blur(); globalLoadingBehavior(); loadLameActionSpan(#{box.id},'up')" }, 
                    :id => "boxid_#{box.id}_title" )
  end
  
  def link_to_remote_for_box_delete(box)
    link_to_remote( content_tag('span', '', :class => 'box_delete'), 
                  { :confirm => 'Are you sure? Deleting a BOX will also delete all the bookmarks within it.',
                    :url => '',
                    :before => 'this.blur(); globalLoadingBehavior()' } )
  end
  
  def link_to_remote_for_box_color_swatches(box,swatch)
    link_to_remote( content_tag('span', '', :class => "box_swatch swatch_#{swatch}"),
                    :url => '',
                    :before => "this.blur(); $('boxid_#{box.id}_style').classNames().set('box #{swatch}')" )
  end
  
  def link_to_remote_for_box_edit_links(box)
    link_to_remote( content_tag('span', '', :class => 'box_edit'),
                    :url => '',
                    :before => "this.blur(); setupModal(#{box.id})",
                    :loading => "Element.show('modal_progress')" )
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
  
  def link_to_remote_for_bookmark_new(box)
    link_to_remote( image_tag('/stylesheets/images/modal/command_new-bookmark2.png', :alt => 'New Bookmark', :class => 'modal_command_new'),
                    :url => '',
                    :before => 'this.blur()' )
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
  
  
  
  
  
  

  
  def bookmark_list_item
    %q|<li id="<%= box_type %>bmark_<%= bmark.id %>" class="dragable_bmarks clearfix <%= box_type %>"><span class="bmrk_handle">&nbsp;</span><span class="boxlink"><a href="<%= h(bmark.url) %>"><%= h(bmark.name) %></a></span></li>|
  end
  

  

  
  
  


  

  
  

  

  
  
  
  def blind_box_parts(box, node, direction)
    case
      when direction == :up
        page["boxid_#{box.id}_#{node}"].visual_effect :blind_up, { :duration => 0.35, :queue => {:position => 'end', :scope => "boxid_#{box.id}"} }
      when direction == :down
        page["boxid_#{box.id}_#{node}"].visual_effect :blind_down, { :duration => 0.35, :queue => {:position => 'end', :scope => "boxid_#{box.id}"} }
    end
  end
  
  def blind_new_box(box)
    page["boxid_#{box.id}"].visual_effect :blind_down, { :duration => 0.35, :queue => {:position => 'end', :scope => "boxid_#{box.id}"} }
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
