require File.dirname(__FILE__) + '/../test_helper'

class InboxesControllerTest < ActionController::TestCase
  
  def setup
    login_as(:bob)
    @bob = users(:bob)
    @inbox = @bob.inbox
    @inbox.bookmarks.clear
    @ibm = @inbox.bookmarks.create :name => 'Test', :url => 'test.com'
  end
  
  context 'While testing the BOOKMARKS action' do

    should 'GET a json representation of bookmarks' do
      get :bookmarks
      assert_response :success
      bm_data = decode_json_response
      assert_instance_of Array, bm_data, 'should be a collection of bookmark data'
      assert_equal 1, bm_data.size, 'should be one bookmark from setup'
      assert_equal @ibm.name, bm_data.first['bookmark']['name']
      assert_equal @ibm.url, bm_data.first['bookmark']['url']
    end
    
  end
  
  
  
end
