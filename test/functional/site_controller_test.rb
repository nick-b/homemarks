require File.dirname(__FILE__) + '/../test_helper'

class SiteControllerTest < ActionController::TestCase
  
  context 'While testing the site root' do
    
    should 'get the index page' do
      get :index
      assert_site_page_success :title => 'Welcome to HomeMarks'
    end
    
    should 'get index page when logged in' do
      login_as(:bob)
      get :index
      assert_site_page_success :title => 'Welcome to HomeMarks'
    end
    
  end
  
  context 'While testing other static pages' do
    
    should 'get pages with basic content assertions' do
      assert_show_site_page_success 'help', :title => 'Documentation & Help'
    end
    
    should 'not show the support form on help page' do
      get_show_page 'help'
      assert_element_hidden '#ajaxforms_wrapper'
    end
    
  end
  
  
  
  protected
  
  def assert_show_site_page_success(page,options={})
    get_show_page(page)
    assert_site_page_success(options)
    assert_template(page)
    assert_instance_of SupportRequest, assigns(:support_request)
  end
  
  def get_show_page(page)
    get :show, {:page => page}
  end
  
  
  
end
