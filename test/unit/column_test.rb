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
  
  context 'While testing columns association for bob' do
    
    setup { @columns = @bob.columns }
    
    should 'be ordered by position' do
      assert_equal [1,2,3], @columns.map(&:position)
    end
    
  end
  
  
  

end