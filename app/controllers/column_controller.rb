class ColumnController < ApplicationController  
  
  verify :xhr => true, :add_flash => {:bad => 'Invalid request method.'}, :redirect_to => :myhome_url
  after_filter :expire_user_home_cache
  
  
  def new
    @column = @user.columns.create
    @remove_welcome = true if (@user.columns.length == 1)
    render :update do |page|
      page.remove :welcome_box if @remove_welcome
      page.insert_html :top, 'col_wrapper', {:partial => 'new_col', :locals => {:col => @column}}
      page.visual_effect :pulsate, "col_#{@column.id}"
      page.reorder_then_create_box_sortables(@column,@user)
      page.create_column_sortable
      page.make_msg('good','Column created.')
    end
  end
  
  def sort
    @column = @user.columns.find(params[:col_id])
    Column.transaction { @column.insert_at(params[:col_position]) }
    render(:update) { |page| page.make_msg('good','Columns sorted.') }
  end
  
  def destroy
    @column = @user.columns.find(params[:id])
    @column.destroy
    render :update do |page|
      page.visual_effect :fade, "col_#{@column.id}", {:duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@column.id}"}}
      page.delay(1) { page["col_#{@column.id}"].remove }
      page.make_msg('good','Column was deleted.')
    end
  end
  
  
end
