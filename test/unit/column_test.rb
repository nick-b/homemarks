require File.dirname(__FILE__) + '/../test_helper'

class ColumnTest < ActiveSupport::TestCase
  
  should_belong_to  :user
  should_have_many  :boxes
  should_protect_attributes :user_id, :position
  
  
  def setup
    @bob = users(:bob)
  end
  
  context 'While testing fixture data and factory methods' do

    should 'have 3 columns for bob' do
      assert_equal 3, @bob.columns.size
    end

  end
  
  context 'Testing model behavior' do
    
    should 'call delete_all_associations after destroy' do
      column = @bob.columns.find(:first)
      column.expects(:delete_all_associations).once
      column.destroy
    end
    
    should 'destroy boxes and bookmarks before column destroyed' do
      @bob.columns.each(&:destroy)
      assert_equal 0, Box.count
      assert_equal 0, Bookmark.count
    end
    
  end
  
  
end


