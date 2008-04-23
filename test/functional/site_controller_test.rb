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
  
  context 'While testing other static pages' do

    should 'get pages with basic content assertions' do
      should_get_static_page 'help', :title => 'Documentation & Help'
    end
    
  end
  
  
  
  protected
  
  def should_get_static_page(page,options={})
    get :show, {:page => page}
    assert_response :success
    assert_select 'h1', /#{h(options[:title])}/i if options[:title]
    should_have_top_navigation
  end
  
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
