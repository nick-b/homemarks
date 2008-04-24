require File.dirname(__FILE__) + '/../test_helper'

class SiteControllerTest < ActionController::TestCase
  
  context 'While testing the site root' do

    should 'get the index page' do
      get :index
      assert_site_page_success :title => 'Welcome to HomeMarks'
    end

  end
  
  context 'While testing other static pages' do

    should 'get pages with basic content assertions' do
      assert_show_site_page_success 'help', :title => 'Documentation & Help'
    end
    
  end
  
  
  
  protected
  
  def assert_show_site_page_success(page,options={})
    get :show, {:page => page}
    assert_site_page_success(options)
    assert_template(page)
    assert_instance_of SupportRequest, assigns(:support_request)
  end
  

  
  
end
