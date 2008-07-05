require File.dirname(__FILE__) + '/../test_helper'

class BoxTest < ActiveSupport::TestCase
  
  def setup
    @bob = users(:bob)
  end
  
  should_belong_to  :column
  should_have_many  :bookmarks
  should_require_attributes       :column_id
  should_protect_attributes       :column_id, :position
  should_allow_values_for         :style, *Box::COLORS
  should_not_allow_values_for     :style, 'foo', 'bar', :message => /not included/
  should_ensure_length_in_range   :title, 0..64
  should_allow_nil_and_blank_for  :style, :title
  
  context 'Testing fixture data and factory methods' do
  
    should 'have 4 boxes' do
      assert_equal 4, @bob.boxes.size
    end
  
  end
  
  context 'Testing model behavior' do
    
    setup { @box = @bob.boxes.find(:first) }

    should 'have a COLORS frozen constant' do
      assert Box::COLORS
      assert Box::COLORS.frozen?
    end
    
    should 'call delete_all_associations after destroy' do
      @box.expects(:delete_all_associations).once
      @box.destroy
    end
    
    should 'destroy bookmarks before box destroy' do
      assert @box.bookmarks.create(:name => '1', :url => '1')
      assert @box.bookmarks.create(:name => '2', :url => '2')
      doomed_bookmark_ids = @box.bookmarks.map(&:id)
      @box.destroy
      doomed_bookmark_ids.each do |bm_id|
        assert_raise(ActiveRecord::RecordNotFound) { Bookmark.find(bm_id) }
      end
    end

  end
  
  
  
end


