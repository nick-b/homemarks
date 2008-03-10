class BoxController < ApplicationController
  
  verify :xhr => true, :add_flash => {:bad => 'Invalid request method.'}, :redirect_to => :myhome_url
  prepend_before_filter :do_nothing_on_lost_box_sort
  after_filter :expire_user_home_cache, :except => [ :actions_down, :actions_up ]
  after_filter :expire_action_boxes, :only => [ :new ]
  
  
  def new
    @col = @user.columns.find(params[:id])
    @box = @col.boxes.create
    render :update do |page|
      page.insert_html :after, "column_#{@col.id}_ctl", {:partial => 'new_box', :locals => {:box => @box}}
      page["boxid_#{@box.id}_controls"].show
      page.create_bookmark_sortables(@user)
      page.reorder_then_create_box_sortables(@col,@user)
      page.create_column_sortable
      page.blind_new_box(@box)
      page.make_msg('good','Box successfully created.')
    end
  rescue
    rescue_action('Box creation failed.', @user, params[:id])
  end
  
  def destroy
    @box = @user.boxes.find(params[:id])
    @boxdiv = "boxid_#{@box.id}"
    @box.destroy
    render :update do |page|
      page[@boxdiv].visual_effect :fade, { :duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@box.id}"} }
      page.delay(1) { page[@boxdiv].remove }
      page.make_msg('good','Box successfully deleted.')
    end
  rescue
    rescue_action('Box delete failed.', @user, params[:id])
  end
  
  
  def actions_down
    @box = @user.boxes.find(params[:id])
    if params[:collapsed] == "true"
      @box.collapsed = false ; @box.save!
    end
    render :update do |page|
      page.blind_box_parts(@box,'inside',:down) if params[:collapsed] == "true"
      page.insert_html :top, "boxid_#{@box.id}_inside", {:partial => 'controls', :locals => {:box => @box}}
      page.delay(0.5) { page.blind_box_parts(@box,'controls',:down) }
      page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'up')
      page.make_msg('good','Box actions displayed.')
    end
  rescue
    rescue_action('Box actions failed.', @user, params[:id])
  end
  
  def actions_up
    @box = @user.boxes.find(params[:id])
    render :update do |page|
      page.blind_box_parts(@box,'controls',:up)
      page.delay(0.5) { page["boxid_#{@box.id}_controls"].remove }
      page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
      page.make_msg('good','Box actions hidden.')
    end
  rescue
    rescue_action('Box actions failed.', @user, params[:id])
  end
  
  
  def collapse
    @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.collapsed")
    case @box.collapsed?
    when true
      @box.collapsed = false
      render :update do |page|
        page.blind_box_parts(@box,'inside',:down)
        page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
        page.make_msg('good','Box uncollapsed.')
      end
    when false
      @box.collapsed = true
      render :update do |page|
        page.blind_box_parts(@box,'inside',:up)
        page.select("div#boxid_#{@box.id}_controls").each { |div| page.delay(0.5){div.remove} }
        page.replace "boxid_#{@box.id}_action_lame", link_to_remote_for_box_actions(@box,'down')
        page.make_msg('good','Box collapsed.')
      end
    end
    @box.save!
  rescue
    rescue_action('Box collapse failed.', @user, params[:id])
  end
  
  
  def change_color
    @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.style")
    @box.style = params[:color]
    @box.save!
    render :nothing => true
  rescue
    rescue_action('Box color change failed.', @user, params[:id])
  end
  
  
  def change_title
    @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.title")
    @box.title = params[:title]
    @box.save!
    render :text => h(@box.title)
  rescue
    rescue_action('Box title change failed.', @user, params[:id])
  end
  
  
  def sort
    @box = @user.boxes.find(params[:box_id])
    @column = @user.columns.find(params[:col_id])
    Box.transaction do
      @box.insert_at(params[:box_position]) if internal_sort?
      @box.insert_at_new_scope_and_position(@column.id, params[:box_position]) if !internal_sort?
    end
    render(:update) { |page| page.make_msg('good','Boxes successfully sorted.') }
  rescue
    rescue_action('Box sorting failed.', @user, params)
  end
  
  
  
  private
  
  def internal_sort?
    return true if (params[:internal_sort] == 'true')
    return false if (params[:internal_sort] == 'false')
  end
  
  def lost_box?
    return true if (params[:lost_box] == 'true')
    return false if (params[:lost_box] == 'false')
  end
  
  def do_nothing_on_lost_box_sort
    if (params[:action] == 'sort') and lost_box?
      render :nothing => true
    end
  end
  
  
  
end








