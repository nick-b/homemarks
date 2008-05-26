require File.dirname(__FILE__) + '/../test_helper'

class TrashboxmarkTest < ActiveSupport::TestCase
  
  should_belong_to  :trashbox
  should_protect_attributes :trashbox_id, :position, :created_at, :visited_at
  
  
  def setup
    @bob = users(:bob)
    @trashbox = @bob.trashbox
    @bookmark_count = @trashbox.bookmarks.size
  end
  
  context 'While testing fixture data and factory methods' do
    
    should 'have 2 bookmarks in bobs inbox' do
      assert_equal 2, @bookmark_count
    end
    
  end
  
  context 'While testing inbox to bookmark association for bob' do
    
    should 'destroy all bookmars in bobs trashbox' do
      lost_boomark_size = 0 - @bookmark_count
      assert_difference 'Trashboxmark.count', lost_boomark_size do
        @bob.destroy
      end
    end
    
  end
  
  

end

