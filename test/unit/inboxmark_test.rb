require File.dirname(__FILE__) + '/../test_helper'

class InboxmarkTest < ActiveSupport::TestCase
  
  should_belong_to  :inbox
  should_protect_attributes :inbox_id, :position, :created_at, :visited_at
  
  
  def setup
    @bob = users(:bob)
    @inbox = @bob.inbox
    @bookmark_count = @inbox.bookmarks.size
  end
  
  context 'While testing fixture data and factory methods' do
    
    should 'have 3 bookmarks in bobs inbox' do
      assert_equal 3, @bookmark_count
    end
    
  end
  
  context 'While testing inbox to bookmark association for bob' do
    
    should 'destroy all bookmars in bobs inbox' do
      lost_boomark_size = 0 - @bookmark_count
      assert_difference 'Inboxmark.count', lost_boomark_size do
        @bob.destroy
      end
    end
    
  end
  
  

end

