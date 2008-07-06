require File.dirname(__FILE__) + '/../test_helper'

class BoxesControllerTest < ActionController::TestCase
  
  should_ignore_lost_sortable_requests
  should_require_login :create  => {:method => :post}, 
                       :destroy => {:method => :delete, :params => {:id => 1}}, 
                       :sort    => {:method => :put}
  
  def setup
    login_as(:bob)
    @bob = users(:bob)
    @column = @bob.columns.last
    @box = @column.boxes.first
  end
  
  context 'The CREATE action' do
    
    should 'create a new box and get back ID of new box in JSON format' do
      assert_difference '@column.boxes.size', 1 do
        xhr :post, :create, :column_id => @column.id
        new_box = assigns(:box)
        assert_instance_of Box, new_box
        assert_json_response
        assert_equal new_box.id, decode_json_response
      end
    end
    
  end
  
  context 'The DESTROY action' do

    should 'destroy box and return head OK response' do
      assert @box
      xhr :delete, :destroy, :id => @box.id
      assert_response :ok
      assert !@column.boxes(true).include?(@box), 'Bobs boxes should not included the one we just destroyed.'
    end
    
  end
  
  context 'The COLORIZE action' do

    should 'update the style attribute and return head OK response' do
      new_color = Box::COLORS.last
      assert @box.update_attribute(:style, nil)
      xhr :put, :colorize, :id => @box.id, :color => new_color
      assert_equal new_color, @box.reload.style
    end

  end
  
  context 'The CHANGE_TITLE action' do

    should 'should update title and return new title in JSON format' do
      new_title = 'My favorite box'
      xhr :put, :change_title, :id => @box.id, :title => new_title
      assert_json_response
      assert_equal new_title, decode_json_response
    end

  end
  
  context 'The TOGGLE_COLLAPSE action' do

    should 'toggle collapse and return JSON true or false' do
      collapsed = @box.collapsed
      xhr :put, :toggle_collapse, :id => @box.id
      assert_json_response
      assert_equal !collapsed, decode_json_response
    end

  end
  
  context 'The SORT action' do

    should 'insert the box at new position and return head OK response' do
      assert @column.boxes.size >= 2
      moved_box = @column.boxes.last
      xhr :put, :sort, :id => moved_box.id, :internal_sort => 'true', :position => 1
      assert_response :ok
      assert_equal 1, moved_box.reload.position
    end
    
    should 'insert the box at new scope and position and return head OK response' do
      to_column = @bob.columns.first
      from_column = @bob.columns.last
      moved_box = from_column.boxes.first
      xhr :put, :sort, :id => moved_box.id, :gained_id => to_column.id, :position => 1
      assert_response :ok
      assert !from_column.boxes(true).include?(moved_box)
      assert to_column.boxes(true).include?(moved_box)
    end

  end
  
  
  
end
