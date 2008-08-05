require File.dirname(__FILE__) + '/../test_helper'

class TrashboxesControllerTest < ActionController::TestCase
  
  def setup
    login_as(:bob)
    @bob = users(:bob)
    @trashbox = @bob.trashbox
    @trashbox.bookmarks.clear
    @tbm = @trashbox.bookmarks.create :name => 'Test', :url => 'test.com'
  end
  
  context 'Testing the BOOKMARKS action' do

    should 'GET a json representation of bookmarks' do
      xhr :get, :bookmarks
      assert_response :success
      bm_data = decode_json_response
      assert_instance_of Array, bm_data, 'should be a collection of bookmark data'
      assert_equal 1, bm_data.size, 'should be one bookmark from setup'
      assert_equal @tbm.name, bm_data.first['bookmark']['name']
      assert_equal @tbm.url, bm_data.first['bookmark']['url']
    end
    
    should 'be ordered' do
      @tbm2 = @trashbox.bookmarks.create :name => 'Test1', :url => 'test1.com'
      get :bookmarks
      assert_response :success
      bm_data = decode_json_response
      assert_equal @tbm2.name, bm_data[0]['bookmark']['name']
      assert_equal @tbm.name, bm_data[1]['bookmark']['name']
    end
    
  end
  
  context 'Testing the DESTROY action' do

    should 'delete all bookmarks in trashbox' do
      assert !@trashbox.empty?
      xhr :delete, :destroy
      assert_response :success
      assert @trashbox.empty?
    end

  end
  
  
  
  
end
