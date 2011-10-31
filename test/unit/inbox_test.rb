require File.dirname(__FILE__) + '/../test_helper'

class InboxTest < ActiveSupport::TestCase

  should_belong_to  :user
  should_have_many  :bookmarks
  should_protect_attributes :user_id


  def setup
    @bob = users(:bob)
  end

  context 'Testing fixture data and factory methods' do

    should 'have an inbox' do
      assert @bob.inbox
    end

  end

  context 'Testing inbox association for bob' do

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

  context 'Testing optgroup construction' do

    should 'have an OptGroup constant for a new struct responding to :id and :title' do
      assert defined?(Inbox::OptGroup), 'should have Inbox::OptGroup defined'
      optgroup = Inbox::OptGroup.new
      assert_instance_of Inbox::OptGroup, optgroup
      assert optgroup.respond_to?(:id)
      assert optgroup.respond_to?(:title)
    end

    should 'build an box optgroup with inbox suitable for all users' do
      optgroup = Inbox.optgroup
      assert_equal 'INBOX', optgroup.col_name
      assert_equal 1, optgroup.boxes.size, 'should have one Inbox::OptGroup object'
      assert_equal 'inbox', optgroup.boxes.first.id
      assert_equal 'My Inbox', optgroup.boxes.first.title
    end

  end



end

