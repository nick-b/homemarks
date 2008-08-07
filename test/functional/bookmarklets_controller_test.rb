require File.dirname(__FILE__) + '/../test_helper'

class BookmarkletsControllerTest < ActionController::TestCase
  
  
  context 'Testing NEW actions' do
    
    should 'redirect to root when no referer is present' do
      get :new
      assert_redirected_to(root_url)
      get :nonhtml
      assert_redirected_to(root_url)
    end
    
  end
  
  context 'Testing NEW action' do

    should 'redirect to site help if self referal' do
      set_referer
      get :new
      assert_response :success, 'should be a JS render'
      assert_equal "window.location='/help#homemarklet'", @response.body
    end
    
  end
  
  
  protected
  
  def set_referer(value=nil)
    referer = value || "http://#{HmConfig.app[:host]}"
    @request.env['HTTP_REFERER'] = referer
  end
  
end
