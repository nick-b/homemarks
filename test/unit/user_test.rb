require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase


  context 'While testing helpers' do

    should 'be able to create a basic user' do
      assert_difference 'User.count' do
        @user = create_user
        assert !@user.new_record?, @user.errors.full_messages.to_sentence
      end
    end

  end
  
  context 'While white box testing User model' do

    should 'description' do
      
    end
    
  end
  
  
  
  
  
end
