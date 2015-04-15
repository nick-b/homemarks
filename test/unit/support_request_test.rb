require File.dirname(__FILE__) + '/../test_helper'

class SupportRequestTest < ActiveSupport::TestCase

  should_belong_to :user
  should_require_attributes   :problem, :details, :email
  should_protect_attributes   :user_id
  should_not_allow_values_for :problem, 'Fubar', 'MadeUp'


  context 'While creating a new record' do

    setup do
      @support = build_suport_request
    end

  end


  protected

  def build_suport_request(overrides={})
    attributes = {:email => 'user@test.com', :problem => 'Account Issues', :details => 'Test'}
    attributes.merge!(overrides)
    SupportRequest.new(attributes)
  end


end
