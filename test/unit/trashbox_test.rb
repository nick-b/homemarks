require File.dirname(__FILE__) + '/../test_helper'

class TrashboxTest < ActiveSupport::TestCase
  
  should_belong_to  :user
  should_have_many  :bookmarks
  should_protect_attributes :user_id
  
  
  def setup
    @bob = users(:bob)
  end
  
  context 'While testing fixture data and factory methods' do
    
    should 'have an traxhbox' do
      assert @bob.trashbox
    end
    
  end
  
  context 'While testing trashbox association' do
    
    setup { @trashbox = @bob.trashbox }
    
    should 'be destroyed when user is' do
      assert_difference 'Trashbox.count', -1 do
        @bob.destroy
      end
    end
    
    should 'return true when there are no bookmarks' do
      assert !@trashbox.empty?
      @trashbox.bookmarks.each(&:destroy)
      assert @trashbox.empty?
    end

  end
  
  
  
end

