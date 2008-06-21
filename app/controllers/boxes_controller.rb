class BoxesController < ApplicationController  
  
  before_filter :find_box, :except => :create
  # after_filter :expire_user_home_cache, :except => [ :actions_down, :actions_up ]
  # after_filter :expire_action_boxes, :only => [ :new ]
  
  
  def create
    @box = current_user.columns.find(params[:column_id]).boxes.create!
    render_json_data(@box.id)
  end
  
  def destroy
    @box.destroy
    head :ok
    # render :update do |page|
    #   page[@boxdiv].visual_effect :fade, { :duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@box.id}"} }
    #   page.delay(1) { page[@boxdiv].remove }
    # end
  end
  
  # def change_color
  #   @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.style")
  #   @box.style = params[:color]
  #   @box.save!
  #   render :nothing => true
  # end
  
  # def change_title
  #   @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.title")
  #   @box.title = params[:title]
  #   @box.save!
  #   render :text => h(@box.title)
  # end
  
  # def actions_down
  #   @box = @user.boxes.find(params[:id])
  #   if params[:collapsed] == "true"
  #     @box.collapsed = false ; @box.save!
  #   end
  #   render :update do |page|
  #     page.blind_box_parts(@box,'inside',:down) if params[:collapsed] == "true"
  #     page.insert_html :top, "boxid_#{@box.id}_inside", {:partial => 'controls', :locals => {:box => @box}}
  #     page.delay(0.5) { page.blind_box_parts(@box,'controls',:down) }
  #     page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'up')
  #     page.make_msg('good','Box actions displayed.')
  #   end
  # end
  
  # def actions_up
  #   render :update do |page|
  #     page.blind_box_parts(@box,'controls',:up)
  #     page.delay(0.5) { page["boxid_#{@box.id}_controls"].remove }
  #     page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
  #     page.make_msg('good','Box actions hidden.')
  #   end
  # end
  
  # def collapse
  #   @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.collapsed")
  #   case @box.collapsed?
  #   when true
  #     @box.collapsed = false
  #     render :update do |page|
  #       page.blind_box_parts(@box,'inside',:down)
  #       page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
  #       page.make_msg('good','Box uncollapsed.')
  #     end
  #   when false
  #     @box.collapsed = true
  #     render :update do |page|
  #       page.blind_box_parts(@box,'inside',:up)
  #       page.select("div#boxid_#{@box.id}_controls").each { |div| page.delay(0.5){div.remove} }
  #       page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
  #       page.make_msg('good','Box collapsed.')
  #     end
  #   end
  #   @box.save!
  # end
  
  def sort
    @box = @user.boxes.find(params[:box_id])
    @column = @user.columns.find(params[:col_id])
    Box.transaction do
      @box.insert_at(params[:box_position]) if internal_sort?
      @box.insert_at_new_scope_and_position(@column.id, params[:box_position]) if !internal_sort?
    end
    head :ok
  end
  
  
  protected
  
  def find_box
    @box = current_user.boxes.find(params[:id])
  end
  
  # def internal_sort?
  #   return true if (params[:internal_sort] == 'true')
  #   return false if (params[:internal_sort] == 'false')
  # end
  # 
  # def lost_box?
  #   return true if (params[:lost_box] == 'true')
  #   return false if (params[:lost_box] == 'false')
  # end
  
  
end
  
  

  

# def actions_down
#   @box = @user.boxes.find(params[:id])
#   if params[:collapsed] == "true"
#     @box.collapsed = false ; @box.save!
#   end
#   render :update do |page|
#     page.blind_box_parts(@box,'inside',:down) if params[:collapsed] == "true"
#     page.insert_html :top, "boxid_#{@box.id}_inside", {:partial => 'controls', :locals => {:box => @box}}
#     page.delay(0.5) { page.blind_box_parts(@box,'controls',:down) }
#     page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'up')
#   end
# end

# def actions_up
#   @box = @user.boxes.find(params[:id])
#   render :update do |page|
#     page.blind_box_parts(@box,'controls',:up)
#     page.delay(0.5) { page["boxid_#{@box.id}_controls"].remove }
#     page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
#   end
# end

# def collapse
#   @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.collapsed")
#   case @box.collapsed?
#   when true
#     @box.collapsed = false
#     render :update do |page|
#       page.blind_box_parts(@box,'inside',:down)
#       page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
#     end
#   when false
#     @box.collapsed = true
#     render :update do |page|
#       page.blind_box_parts(@box,'inside',:up)
#       page.select("div#boxid_#{@box.id}_controls").each { |div| page.delay(0.5){div.remove} }
#       page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
#     end
#   end
#   @box.save!
# end
  

