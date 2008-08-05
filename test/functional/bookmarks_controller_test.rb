require File.dirname(__FILE__) + '/../test_helper'

class BookmarksControllerTest < ActionController::TestCase
  
  class << self
    
    def should_raise_argument_error_for_bad_type_params(action)
      should 'raise an argument error for bad type params' do
        assert_raise(ArgumentError) { xhr(:put, action, :id => 1, :type => 'Foobar') }
      end
    end
    
  end
  
  should_ignore_lost_sortable_requests
  
  
  def setup
    login_as(:bob)
    @bob = users(:bob)
    @box_bookmark = bookmarks(:bob_col1_box1_bmark1)
    @in_bookmark = bookmarks(:bob_ibmark1)
    @trash_bookmark = bookmarks(:bob_tbmark1)
  end
  
  context 'The SHOW action' do
    
    should 'be able to find BOX bookmark by id and type' do
      assert_equal 'Box', @box_bookmark.owner_type
      assert_bookmark_assign_and_json_response(@box_bookmark)
    end
    
    should 'be able to find INBOX bookmark by id and type' do
      assert_equal 'Inbox', @in_bookmark.owner_type
      assert_bookmark_assign_and_json_response(@in_bookmark)
    end
    
    should 'be able to find TRASBOX bookmark by id and type' do
      assert_equal 'Trashbox', @trash_bookmark.owner_type
      assert_bookmark_assign_and_json_response(@trash_bookmark)
    end
    
  end
  
  context 'The TRASH action' do
    
    should_raise_argument_error_for_bad_type_params(:trash)

    should 'move normal bookmark to trash and return head :ok' do
      xhr :put, :trash, :type => @box_bookmark.owner_type, :id => @box_bookmark.id
      assert_response :ok
      @box_bookmark.reload
      assert @box_bookmark.trashbox?
      assert_equal 1, @box_bookmark.position
    end

  end
  
  context 'The SORT action' do
    
    should_raise_argument_error_for_bad_type_params(:sort)
    
    should 'move 1st inbox bookmark to 1st box' do
      box = boxes(:bob_col1_box1)
      xhr :put, :sort, :id => @in_bookmark.id, :old_type => 'Inbox', :type => 'Box', :gained_id => box.id, :position => 1
      assert_response :ok
      assert @in_bookmark.reload.box?
      assert_equal box.id, @in_bookmark.owner_id
    end
    
    should 'move 2nd box bookmark to 1st position' do
      bm1 = bookmarks(:bob_col1_box1_bmark1)
      bm2 = bookmarks(:bob_col1_box1_bmark2)
      xhr :put, :sort, :id => bm2.id, :internal_sort => 'true', :type => 'Box', :position => 1
      assert_response :ok
      assert bm2.reload.box?
      assert_equal 1, bm2.reload.position
      assert_equal 2, bm1.reload.position
    end

  end
  
  
  
  protected
  
  def assert_bookmark_assign_and_json_response(bookmark)
    xhr :get, :show, :id => bookmark.id, :type => bookmark.owner_type
    assert_response :success
    assert_json_response
    assert_equal bookmark, assigns(:bookmark)
    assert_equal bookmark.url, decode_json_response['bookmark']['url']
    assert_equal bookmark.name, decode_json_response['bookmark']['name']
  end
  
  
end
