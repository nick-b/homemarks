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
  end
  
  def colorize
    @box.update_attributes! :style => params[:color]
    head :ok
  end
  
  # def change_title
  #   @box = @user.boxes.find(params[:id], :select => "boxes.id, boxes.title")
  #   @box.title = params[:title]
  #   @box.save!
  #   render :text => h(@box.title)
  # end
  
  def toggle_collapse
    @box.toggle(:collapsed).save!
    render_json_data(@box.collapsed?.to_s)
  end
  
  def sort
    
    # @column = current_user.columns.find(params[:col_id])
    Box.transaction do
      @box.insert_at(params[:position]) #if internal_sort?
      # @box.insert_at_new_scope_and_position(@column.id, params[:box_position]) if !internal_sort?
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


