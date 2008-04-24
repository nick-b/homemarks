require File.dirname(__FILE__) + '/../test_helper'

class SupportRequestsControllerTest < ActionController::TestCase
  
  context 'While testing the new action' do

    should 'get the page with success and new instance var' do
      get :new
      assert_site_page_success :title => 'Issues & Support'
      assert_instance_of SupportRequest, assigns(:support_request)
      assert assigns(:support_request).new_record?
    end

    should 'not show the form' do
      get :new
      assert_element_hidden '#ajaxforms_wrapper'
    end
    
    should 'show the form when params allow it' do
      get :new, {:show_form => 'true'}
      assert_element_visible '#ajaxforms_wrapper'
    end
    
  end
  
  
  
end
