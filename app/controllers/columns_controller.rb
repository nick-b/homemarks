class ColumnsController < ApplicationController  
  
  prepend_before_filter :ignore_lost_sortable_requests
  before_filter         :find_column, :except => :create
  
  
  def create
    @column = current_user.columns.create!
    render_json_data(@column.id)
  end
  
  def destroy
    @column.destroy
    head :ok
  end
  
  def sort
    @column.insert_at(params[:position]) 
    head :ok
  end
  
  
  protected
  
  def find_column
    @column = current_user.columns.find(params[:id])
  end
  
  
end

