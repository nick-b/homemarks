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
    
    should 'populate support form with user email when logged in' do
      login_as(:bob)
      get :new, {:show_form => 'true'}
      assert_select 'input#support_request_email[value=?]', users(:bob).email
    end
    
  end
  
  context 'While testing the create action' do
    
    should 'create a new support request' do
      xhr_create_support_request
      assert_instance_of SupportRequest, assigns(:support_request)
      assert_response :success, "object was not saved, errors are #{inspect_errors(assigns(:support_request))}"
    end
    
    should 'create a new support request bound to a user when logged in' do
      login_as(:bob)
      xhr_create_support_request
      assert_equal users(:bob), assigns(:support_request).user
    end

  end
  
  
  protected
  
  def xhr_create_support_request
    xhr :post, :create, {:support_request => {:email => 'user@test.com', :problem => 'Account Issues', :details => 'Test'}}
  end
  
  
end
