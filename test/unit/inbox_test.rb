require File.dirname(__FILE__) + '/../test_helper'

class InboxTest < ActiveSupport::TestCase
  
  should_belong_to  :user
  should_have_many  :bookmarks
  should_protect_attributes :user_id
  
  
  def setup
    @bob = users(:bob)
  end
  
  context 'While testing fixture data and factory methods' do
    
    should 'have an inbox' do
      assert @bob.inbox
    end
    
  end
  
  context 'While testing inbox association for bob' do
    
    setup { @inbox = @bob.inbox }
    
    should 'be destroyed when user is' do
      assert_difference 'Inbox.count', -1 do
        @bob.destroy
      end
    end
    
    should 'destroy bookmarks along with itself' do
      assert_difference 'Bookmark.count', -3 do
        @inbox.destroy
      end
    end

  end
  
  
  

end

