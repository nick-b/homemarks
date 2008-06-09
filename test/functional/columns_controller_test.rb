require File.dirname(__FILE__) + '/../test_helper'

class ColumnsControllerTest < ActionController::TestCase
  
  should_require_login :create  => {:method => :post}, 
                       :destroy => {:method => :delete, :params => {:id => 1}}, 
                       :sort    => {:method => :put}
  
  def setup
    login_as(:bob)
    @bob = users(:bob)
  end
  
  context 'Testing the CREATE action' do
    
    should 'create a new colum and get back ID of new column in JSON format' do
      xhr :post, :create
      new_column = assigns(:column)
      assert_instance_of Column, new_column
      assert_json_response
      assert_equal new_column.id, decode_json_response
    end
    
  end
  
  context 'Testing the DESTROY action' do

    should 'delete column and return head OK response' do
      doomed_column = @bob.columns.first
      xhr :delete, :destroy, :id => doomed_column.id
      assert_response :ok
      assert !@bob.columns(true).include?(doomed_column), 'Bobs columns should not included the one we just destroyed.'
    end

  end
  
  context 'Testing the SORT action' do

    should 'insert the column at new position and return head OK response' do
      moved_column = @bob.columns.first
      to_position = @bob.columns.size
      xhr :put, :sort, :id => moved_column.id, :position => to_position
      assert_response :ok
      assert_equal to_position, @bob.columns.find(moved_column.id).position
    end

  end
  
  
  
end
