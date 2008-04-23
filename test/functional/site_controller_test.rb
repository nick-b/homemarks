require File.dirname(__FILE__) + '/../test_helper'

class SiteControllerTest < ActionController::TestCase
  
  context 'While testing the site root' do

    should 'get the index page' do
      get :index
      should_have_basic_page_success :title => 'Welcome to HomeMarks'
    end

  end
  
  context 'While testing other static pages' do

    should 'get pages with basic content assertions' do
      should_get_page 'help', :title => 'Documentation & Help'
    end
    
  end
  
  
  
  protected
  
  def should_get_page(page,options={})
    get :show, {:page => page}
    should_have_basic_page_success
    assert_template(page)
    assert_instance_of SupportRequest, assigns(:support_request), 'all content pages should get a support request object'
  end
  
  def should_have_basic_page_success(options={})
    assert_response :success
    assert_select 'h1', /#{h(options[:title])}/i if options[:title]
    should_have_site_navigation
  end
  
  
end
