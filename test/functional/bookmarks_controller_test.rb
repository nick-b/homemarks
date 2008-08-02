require File.dirname(__FILE__) + '/../test_helper'

class BookmarksControllerTest < ActionController::TestCase
  
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

    setup do
      # { :_method => "put", :type => "Box", :id => "109" }
    end

    should 'description' do
      
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
