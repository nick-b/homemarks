require File.dirname(__FILE__) + '/../test_helper'

class SupportRequestTest < ActiveSupport::TestCase
  
  should_belong_to :user
  should_require_attributes :problem, :details, :email
  should_protect_attributes :user_id
  
  
  context 'While creating a new record' do

    setup do
      @support = build_suport_request
    end

    should 'not allow bad problem attributes' do
      assert_valid @support
      @support.problem = 'Foobar'
      assert !@support.valid?, inspect_errors(@support)
      assert_match 'not included', @support.errors.on(:problem) 
    end
    
  end
  
  
  
  protected
  
  def build_suport_request(overrides={})
    attributes = {:email => 'user@test.com', :problem => 'Account Issues', :details => 'Test'}
    attributes.merge!(overrides)
    SupportRequest.new(attributes)
  end
  
  
end
