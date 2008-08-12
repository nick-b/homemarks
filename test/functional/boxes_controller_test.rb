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
  
  context 'The BOOKMARKS action' do
    
    setup do
      @bm1 = @box.bookmarks[0]
      @bm2 = @box.bookmarks[1]
    end
    
    should 'have known fixture data' do
      assert_equal 1038124156, @bm1.id
      assert_equal 'Reddit', @bm1.name
      assert_equal 'www.reddit.com', @bm1.url
      assert_equal 1038124157, @bm2.id
      assert_equal 'Rubyflow', @bm2.name
      assert_equal 'www.rubyflow.com', @bm2.url
    end
    
    should 'return empty updated_bookmarks and new_bookmark arrays with no put data' do
      xhr :put, :bookmarks, :id => @box.id
      assert_json_response
      assert_equal [], decode_json_response['updated_bookmarks']
      assert_equal [], decode_json_response['new_bookmarks']
    end
    
    should 'update existing bookmarks' do
      new_bm1_name = 'Red'
      new_bm1_url = 'www.red.com'
      xhr :put, :bookmarks, :id => @box.id, :bookmarks => {
        '1038124156' => {:name => new_bm1_name, :url => new_bm1_url}, 
        '1038124157' => {:name => @bm2.name, :url => @bm2.url} }
      assert_json_response
      assert jr = decode_json_response
      assert_equal [], jr['new_bookmarks']
      assert_equal 1, jr['updated_bookmarks'].size
      assert bm1_data = jr['updated_bookmarks'][0]['bookmark']
      assert_equal new_bm1_name, bm1_data['name']
      assert_equal new_bm1_url, bm1_data['url']
      assert_equal new_bm1_name, @bm1.reload.name
      assert_equal new_bm1_url, @bm1.reload.url
    end
    
    should 'create new bookmarks' do
      new_bm_name = 'Test'
      new_bm_url = 'http://www.test.com/'
      xhr :put, :bookmarks, :id => @box.id, :bookmarks => {
        '1038124156' => {:name => @bm1.name, :url => @bm1.url}, 
        '1038124157' => {:name => @bm2.name, :url => @bm2.url} }, 
        :new_bookmarks => {'1' => {:name => new_bm_name, :url => new_bm_url}}
      assert_json_response
      assert jr = decode_json_response
      assert_equal [], jr['updated_bookmarks']
      assert_equal 1, jr['new_bookmarks'].size
      assert new_data = jr['new_bookmarks'][0]['bookmark']
      assert_equal new_bm_name, new_data['name']
      assert_equal new_bm_url, new_data['url']
    end
    
  end
  
  
end
