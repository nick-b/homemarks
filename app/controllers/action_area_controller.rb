# TODO: Kill this controller.
class ActionAreaController < ApplicationController
  
  verify :xhr => true, :add_flash => {:bad => 'Invalid request method.'}, :redirect_to => :myhome_url
  
  
  def inbox
    @inbox = @user.inbox if !user_inbox_cache?
    render :update do |page|
      page.replace_html :inbox_list, :partial => 'action_area/inbox_list'
      page.complete_action_area('inbox_list')
    end
  end
  
  def trashbox
    @trashbox = @user.trashbox if !user_trashbox_cache?
    render :update do |page|
      page.replace_html :trashbox_list, :partial => 'action_area/trashbox_list'
      page.complete_action_area('trashbox_list')
      page.<< "showOrHideEmptyTrashBox();"
    end
  end
  
  def empty_trash
    @user.trashbox.bookmarks.delete_all
    expire_user_trashbox_cache
    render :update do |page|
      page.remove_all_trashboxmark_ui_elements_and_message(true)
      page['trashbox_list'].visual_effect :blind_up, { :duration => 0.35 }
      page.delay(0.5) do 
        page.replace_html :trashbox_list, :inline => ''
        page.<< "$('trashbox_list').show();"
      end
    end
  end
  
  
  
end
