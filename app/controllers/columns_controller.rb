class ColumnsController < ApplicationController  
  
  before_filter :find_column, :except => :create
  # after_filter :expire_user_home_cache
  
  
  def create
    # Column.delete_all
    @column = current_user.columns.create!
    render_json_data(@column.id)
  end
  
  def sort
    @column.insert_at(params[:position])
    head :ok
  end
  
  def destroy
    @column.destroy
    head :ok
    # render :update do |page|
    #   page.visual_effect :fade, "col_#{@column.id}", {:duration => 0.4, :queue => {:position => 'end', :scope => "boxid_#{@column.id}"}}
    #   page.delay(1) { page["col_#{@column.id}"].remove }
    # end
  end
  
  
  protected
  
  def find_column
    @column = current_user.columns.find(params[:id])
  end
  
  
end

