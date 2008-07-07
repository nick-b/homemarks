require File.dirname(__FILE__) + '/../test_helper'

class BookmarkTest < ActiveSupport::TestCase
  
  def setup
    @bob = users(:bob)
  end
  
  should_belong_to  :box
  should_require_attributes       :box_id
  should_protect_attributes       :box_id, :position, :created_at
  should_ensure_length_in_range   :url, 0..1024
  should_ensure_length_in_range   :name, 0..255
  
  
  context 'Testing fixture data and factory methods' do
  
    should 'have 4 boxes' do
      assert_equal 4, @bob.boxes.map(&:bookmarks).flatten.size
    end
  
  end
  
  
  
end


