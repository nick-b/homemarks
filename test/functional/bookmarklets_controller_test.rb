require File.dirname(__FILE__) + '/../test_helper'

class BookmarkletsControllerTest < ActionController::TestCase

  def setup
    @bob = users(:bob)
  end

  context 'Testing NEW actions' do

    should 'redirect to root when no referer is present' do
      get :new
      assert_redirected_to(root_url)
      get :nonhtml
      assert_redirected_to(root_url)
    end

  end

  context 'Testing NEW action' do

    setup { set_referer }

    should 'redirect to site help if self referal' do
      set_referer "http://#{HmConfig.app[:host]}"
      get :new
      assert_response :success, 'should be a JS render'
      assert_equal %|window.location.href = "http://test.host/help#homemarklet";|, @response.body
    end

    should 'find bob user by his UUID' do
      get :new, :uuid => @bob.uuid
      assert_response :success
      assert_current_user
    end

    should 'redirect to site root if user not found' do
      get :new, :uuid => '12345678901234567890123456789012'
      assert_response :success
      assert_response :success, 'should be a JS render'
      assert_equal %|window.location.href = "http://test.host/";|, @response.body
    end

  end


  protected

  def set_referer(value=nil)
    referer = value || 'http://www.example.com/'
    @request.env['HTTP_REFERER'] = referer
  end

end
