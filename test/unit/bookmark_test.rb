require File.dirname(__FILE__) + '/../test_helper'

class BookmarkTest < ActiveSupport::TestCase
  
  should_belong_to  :owner
  should_require_attributes       :owner_id, :owner_type
  should_protect_attributes       :owner_id, :owner_type, :position, :created_at
  should_ensure_length_in_range   :url, 0..1024
  should_ensure_length_in_range   :name, 0..255
  should_allow_values_for         :owner_type, *Bookmark::OWNER_TYPES
  should_not_allow_values_for     :owner_type, 'Foo', 'Bar', :message => /not included/
  
  
  def setup
    @bob = users(:bob)
    @box = @bob.boxes.first
    @inbox = @bob.inbox
    @trashbox = @bob.trashbox
  end
  
  context 'Testing fixture data and factory methods' do
  
    should 'have 4 bookmarks in all boxes' do
      assert_equal 4, @bob.boxes.map(&:bookmarks).flatten.size
    end
    
    should 'have 2 bookmarks in test BOX' do
      assert_equal 2, @box.bookmarks.size
    end
    
    should 'have 3 bookmarks in test INBOX' do
      assert_equal 3, @inbox.bookmarks.size
    end
    
    should 'have 2 bookmarks in test TRASHBOX' do
      assert_equal 2, @trashbox.bookmarks.size
    end
    
  end
  
  context 'Testing class' do

    should 'have a OWNER_TYPES frozen constant' do
      constant = Bookmark::OWNER_TYPES
      assert_instance_of Array, constant
      assert_equal ['Box','Inbox','Trashbox'], constant
      assert constant.frozen?
    end

  end
  
  context 'Testing instance behavior' do
    
    setup do
      @bm = @box.bookmarks.first
      @inbm = @inbox.bookmarks.first
      @trbm = @trashbox.bookmarks.first
    end
    
    should 'have query methods for owner types' do
      Bookmark::OWNER_TYPES.each do |type|
        assert @bm.respond_to?("#{type.downcase}?")
      end
    end
    
    should 'respond true to their own owner types' do
      assert @bm.box?
      assert @inbm.inbox?
      assert @trbm.trashbox?
    end
    
    should 'respond false to other owner types' do
      assert !@bm.inbox?
      assert !@inbm.box?
      assert !@trbm.inbox?
    end
    
    should 'all have acces to their user' do
      assert_equal @bob, @bm.user
      assert_equal @bob, @inbm.user
      assert_equal @bob, @trbm.user
    end
    
    context 'for #to_box method' do
      
      setup do
        @bm1 = @box.bookmarks[0]
        @bm2 = @box.bookmarks[1]
        @im1 = @inbox.bookmarks[0]
        @im2 = @inbox.bookmarks[1]
        @im3 = @inbox.bookmarks[2]
        @tm1 = @trashbox.bookmarks[0]
        @tm2 = @trashbox.bookmarks[1]
      end
      
      should 'be setup correctly' do
        assert [@bm1,@bm2].all?(&:box?)
        assert [@im1,@im2,@im3].all?(&:inbox?)
        assert [@tm1,@tm2].all?(&:trashbox?)
      end
      
      should 'be able to convert owner' do
        @bm1.to_box(:inbox)
        assert @bm1.inbox?
      end
      
      should 'move BOX bookmark to trash at 1st position' do
        @bm1.to_box(:trashbox)
        assert @bm1.trashbox?
        assert_equal 1, @bm1.position, 'should be moved to first in trash box list'
        assert_equal 1, @bm2.reload.position, 'last box bookmark should now be in first position'
        assert_equal 2, @tm1.reload.position, 'first trash bookmark should have moved to second'
        assert_equal 3, @tm2.reload.position, 'second trash bookmark should have moved to third'
      end
      
      should 'move INBOX bookmark to 2rd position in box' do
        bm = @im2
        to_box = @bm1.owner
        bm.to_box(to_box.id,2)
        assert bm.box?
        assert_equal 2, @im3.reload.position, 'should be moved to second inbox position'
        assert_equal 1, @bm1.reload.position
        assert_equal 2, bm.reload.position
        assert_equal 3, @bm2.reload.position
      end
      
      should 'have a #trash! method that calls #to_box with :trashbox arg' do
        assert @bm1.respond_to?(:trash!)
        @bm1.expects(:to_box).with(:trashbox)
        @bm1.trash!
      end

    end

  end
  
  
  
  
end


