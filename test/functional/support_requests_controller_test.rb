require File.dirname(__FILE__) + '/../test_helper'

class SupportRequestsControllerTest < ActionController::TestCase
  
  context 'While testing the new action' do

    should 'get the page with success and new instance var' do
      get :new
      assert_site_page_success :title => 'Issues & Support'
      assert_instance_of SupportRequest, assigns(:support_request)
      assert assigns(:support_request).new_record?
    end

    should 'not show the support form' do
      get :new
      assert_element_hidden '#ajaxforms_wrapper'
    end
    
    should 'show the support form when params allow it' do
      get :new, {:show_form => 'true'}
      assert_element_visible '#ajaxforms_wrapper'
    end
    
  end
  
  context 'While testing the create action' do

    should 'create a new support request' do
      xhr :post, :create, {:support_request => {:email => 'user@test.com', :problem => 'Account Issues', :details => 'Test'}}
      assert_instance_of SupportRequest, assigns(:support_request)
      assert_response :success, "object was not saved, errors are #{inspect_errors(assigns(:support_request))}"
    end

  end
  
  
  
  
end
