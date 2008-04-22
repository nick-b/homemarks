require File.dirname(__FILE__) + '/../test_helper'

class SiteControllerTest < ActionController::TestCase
  
  context 'While testing the site root' do

    should 'get the index page' do
      get :index
      assert_response :success
      assert_select 'h1', /Welcome to HomeMarks/i
      should_have_top_navigation
    end

  end
  
  
  protected
  
  def should_have_top_navigation(logged_in=false)
    standard_nav_names = /Home|Help/
    stateful_nav_names = logged_in ? /My HomeMarks|Logout/ : /Login/
    all_nav_names      = Regexp.union(standard_nav_names,stateful_nav_names)
    navigation_count   = logged_in ? 4 : 3
    assert_select '#site_links a', { :count => navigation_count, :text => all_nav_names }
    assert_select '#site_links a' do
      assert_select 'img', true, 'should have an image tag inside all nav items'
      assert_select 'img[alt=?]', all_nav_names
    end
  end
  
end
