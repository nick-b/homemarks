require 'test/unit'
require 'rubygems'
gem 'activerecord', '>= 2.0.2' # TODO: Chage me to 2.1
require 'active_record'
require 'active_support'

require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :mixins do |t|
      t.column :pos, :integer
      t.column :parent_id, :integer
      t.column :created_at, :datetime      
      t.column :updated_at, :datetime
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Mixin < ActiveRecord::Base ; end

class ListMixin < Mixin
  acts_as_list :column => "pos", :scope => :parent_id
  set_table_name :mixins
end

class ListMixinSub1 < ListMixin ; end
class ListMixinSub2 < ListMixin ; end

class ListWithStringScopeMixin < ActiveRecord::Base
  acts_as_list :column => "pos", :scope => 'parent_id = #{parent_id}'
  set_table_name :mixins
end


class ListTest < Test::Unit::TestCase
  
  def setup
    setup_db
    (1..4).each { |counter| ListMixin.create! :pos => counter, :parent_id => 5 }
  end
  
  def teardown
    teardown_db
  end
  
  def test_reordering
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(2).move_lower
    assert_equal [4, 3, 1, 2], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(2).move_higher
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(4).move_to_bottom
    assert_equal [3, 2, 1, 4], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(4).move_to_top
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(3).move_to_bottom
    assert_equal [4, 2, 1, 3], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(4).move_to_top
    assert_equal [4, 2, 1, 3], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
  end
  
  def test_move_to_bottom_with_next_to_last_item
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(2).move_to_bottom
    assert_equal [4, 3, 1, 2], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
  end
  
  def test_next_prev
    assert_equal ListMixin.find_by_pos(2), ListMixin.find_by_pos(1).lower_item
    assert_nil ListMixin.find_by_pos(1).higher_item
    assert_equal ListMixin.find_by_pos(3), ListMixin.find_by_pos(4).higher_item
    assert_nil ListMixin.find_by_pos(4).lower_item
  end
  
  def test_injection
    item = ListMixin.new(:parent_id => 1)
    assert_equal "parent_id = 1", item.scope_condition
    assert_equal "pos", item.position_column
  end
  
  def test_insert
    n1 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n1.pos
    assert n1.first?
    assert n1.last?
    n2 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n2.pos
    assert n2.first?
    assert !n2.last?
    assert n1.reload.last?
    n3 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n3.pos
    assert n3.first?
    assert !n3.last?
    assert n1.reload.last?
    n4 = ListMixin.create(:parent_id => 0)
    assert_equal 1, n4.pos
    assert n4.first?
    assert n4.last?
  end
  
  def test_insert_at
    # Setup and test along the way.
    n1 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n1.pos
    n2 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n2.pos
    assert_equal 2, n1.reload.pos
    n3 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n3.pos
    assert_equal 2, n2.reload.pos
    assert_equal 3, n1.reload.pos
    n4 = ListMixin.create(:parent_id => 20)
    [n1,n2,n3,n4].each(&:reload)
    assert_equal [n4.id, n3.id, n2.id, n1.id], ListMixin.find(:all,:conditions=>'parent_id = 20',:order=>:pos).map(&:id)
    # Testing insert at.
    n1.insert_at(3)
    [n1,n2,n3,n4].each(&:reload)
    assert_equal [n4.id, n3.id, n1.id, n2.id], ListMixin.find(:all,:conditions=>'parent_id = 20',:order=>:pos).map(&:id)
    n1.insert_at(2)
    [n1,n2,n3,n4].each(&:reload)
    assert_equal [n4.id, n1.id, n3.id, n2.id], ListMixin.find(:all,:conditions=>'parent_id = 20',:order=>:pos).map(&:id)
    n5 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n5.pos
    n5.insert_at(5)
    [n1,n2,n3,n4,n5].each(&:reload)
    assert_equal [n4.id, n1.id, n3.id, n2.id, n5.id], ListMixin.find(:all,:conditions=>'parent_id = 20',:order=>:pos).map(&:id)
  end
  
  def test_delete_middle
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find_by_pos(2).destroy
    assert_equal [4, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    assert_equal 3, ListMixin.find(1).pos
    assert_equal 2, ListMixin.find(2).pos
    assert_equal 1, ListMixin.find(4).pos
    ListMixin.find(4).destroy
    assert_equal [2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    assert_equal 1, ListMixin.find(2).pos
    assert_equal 2, ListMixin.find(1).pos
  end
  
  def test_with_string_based_scope
    n = ListWithStringScopeMixin.create(:parent_id => 500)
    assert_equal 1, n.pos
    assert n.first?
    assert n.last?
  end
  
  def test_nil_scope
    n1, n2, n3 = ListMixin.create, ListMixin.create, ListMixin.create
    n2.move_higher
    assert_equal [n3.id, n2.id, n1.id], ListMixin.find(:all, :conditions => 'parent_id IS NULL', :order => 'pos').map(&:id)
  end
  
  def test_remove_from_list_should_then_fail_in_list? 
    assert_equal true, ListMixin.find(1).in_list?
    ListMixin.find(1).remove_from_list
    assert_equal false, ListMixin.find(1).in_list?
  end
  
  def test_remove_from_list_should_set_position_to_nil 
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(3).remove_from_list
    assert_equal [4, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5 AND pos IS NOT NULL', :order => 'pos').map(&:id)
    assert_equal 1,   ListMixin.find(4).pos
    assert_equal nil, ListMixin.find(3).pos
    assert_equal 2,   ListMixin.find(2).pos
    assert_equal 3,   ListMixin.find(1).pos
  end 
  
  def test_remove_before_destroy_does_not_shift_lower_items_twice 
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    ListMixin.find(2).remove_from_list 
    ListMixin.find(2).destroy 
    assert_equal [4, 3, 1], ListMixin.find(:all, :conditions => 'parent_id = 5', :order => 'pos').map(&:id)
    assert_equal 1, ListMixin.find(4).pos
    assert_equal 2, ListMixin.find(3).pos
    assert_equal 3, ListMixin.find(1).pos
  end
  
  def test_insert_at_new_scope_and_position
    (1..4).each { |counter| ListMixin.create! :pos => counter, :parent_id => 420 }
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [8, 7, 6, 5], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
    moving = ListMixin.find(3)
    moving.insert_at_new_scope_and_position(420,2)
    assert_equal [4, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [8, 3, 7, 6, 5], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
    moving = ListMixin.find(4)
    moving.insert_at_new_scope_and_position(420,1)
    assert_equal [2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [4, 8, 3, 7, 6, 5], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
  end
  
  def test_insert_at_new_scope_and_position_at_one_greater_than_new_last
    (1..4).each { |counter| ListMixin.create! :pos => counter, :parent_id => 420 }
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [8, 7, 6, 5], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
    moving = ListMixin.find(3)
    moving.insert_at_new_scope_and_position(420,5)
    assert_equal [4, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [8, 7, 6, 5, 3], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
  end
  
  def test_insert_at_new_scope_and_position_to_much_bigger_scope_list
    (1..8).each { |counter| ListMixin.create! :pos => counter, :parent_id => 420 }
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [12, 11, 10, 9, 8, 7, 6, 5], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
    moving = ListMixin.find(3)
    moving.insert_at_new_scope_and_position(420,9)
    assert_equal [4, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [12, 11, 10, 9, 8, 7, 6, 5, 3], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
  end
  
  def test_insert_at_new_scope_and_position_to_empty_scope
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    moving = ListMixin.find(3)
    moving.insert_at_new_scope_and_position(86,1)
    assert_equal [4, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [3], ListMixin.find(:all, :conditions => {:parent_id => 86}, :order => 'pos').map(&:id)
  end
  
  def test_insert_at_new_scope_and_position_position_error
    (1..4).each { |counter| ListMixin.create! :pos => counter, :parent_id => 420 }
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5}, :order => 'pos').map(&:id)
    assert_equal [8, 7, 6, 5], ListMixin.find(:all, :conditions => {:parent_id => 420}, :order => 'pos').map(&:id)
    moving = ListMixin.find(3)
    assert_raise(ActiveRecord::Acts::List::PositionError) { moving.insert_at_new_scope_and_position(420,6) }
  end
  
  def test_first_of_two_destroy
    list1 = ListMixin.create! :parent_id => 12
    list2 = ListMixin.create! :parent_id => 12
    [list1,list2].each(&:reload)
    assert_nothing_raised { list1.destroy }
  end
  
end




class ListSubTest < Test::Unit::TestCase
  
  def setup
    setup_db
    (1..4).each { |i| ((i % 2 == 1) ? ListMixinSub1 : ListMixinSub2).create! :pos => i, :parent_id => 5000 }
  end
  
  def teardown
    teardown_db
  end
  
  def test_reordering
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
    ListMixin.find(3).move_lower
    assert_equal [4, 2, 3, 1], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
    ListMixin.find(3).move_higher
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
    ListMixin.find(4).move_to_bottom
    assert_equal [3, 2, 1, 4], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
    ListMixin.find(4).move_to_top
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
    ListMixin.find(3).move_to_bottom
    assert_equal [4, 2, 1, 3], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
    ListMixin.find(1).move_to_top
    assert_equal [1, 4, 2, 3], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
  end
  
  def test_move_to_bottom_with_next_to_last_item
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
    ListMixin.find(2).move_to_bottom
    assert_equal [4, 3, 1, 2], ListMixin.find(:all, :conditions => 'parent_id = 5000', :order => 'pos').map(&:id)
  end
  
  def test_next_prev
    assert_equal ListMixin.find(3), ListMixin.find(4).lower_item
    assert_nil ListMixin.find(4).higher_item
    assert_equal ListMixin.find(2), ListMixin.find(1).higher_item
    assert_nil ListMixin.find(1).lower_item
  end
  
  def test_injection
    item = ListMixin.new("parent_id"=>1)
    assert_equal "parent_id = 1", item.scope_condition
    assert_equal "pos", item.position_column
  end
  
  def test_insert_at
    # Setup and test along the way.
    n1 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n1.pos
    n2 = ListMixinSub1.create(:parent_id => 20)
    assert_equal 1, n2.pos
    n3 = ListMixinSub2.create(:parent_id => 20)
    assert_equal 1, n3.pos
    n4 = ListMixin.create(:parent_id => 20)
    assert_equal 1, n4.pos
    [n1,n2,n3,n4].each(&:reload)
    assert_equal [n4.id, n3.id, n2.id, n1.id], ListMixin.find(:all,:conditions=>{:parent_id => 20},:order=>:pos).map(&:id)
    # Testing insert at.
    n1.insert_at(3)
    [n1,n2,n3,n4].each(&:reload)
    assert_equal [n4.id, n3.id, n1.id, n2.id], ListMixin.find(:all,:conditions=>{:parent_id => 20},:order=>:pos).map(&:id)
    n1.insert_at(2)
    [n1,n2,n3,n4].each(&:reload)
    assert_equal [n4.id, n1.id, n3.id, n2.id], ListMixin.find(:all,:conditions=>{:parent_id => 20},:order=>:pos).map(&:id)
    n5 = ListMixinSub1.create(:parent_id => 20)
    assert_equal 1, n5.pos
    n5.insert_at(5)
    [n1,n2,n3,n4,n5].each(&:reload)
    assert_equal [n4.id, n1.id, n3.id, n2.id, n5.id], ListMixin.find(:all,:conditions=>{:parent_id => 20},:order=>:pos).map(&:id)
  end
  
  def test_delete_middle
    assert_equal [4, 3, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5000}, :order => 'pos').map(&:id)
    ListMixin.find(3).destroy
    assert_equal [4, 2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5000}, :order => 'pos').map(&:id)
    assert_equal 1, ListMixin.find(4).pos
    assert_equal 2, ListMixin.find(2).pos
    assert_equal 3, ListMixin.find(1).pos
    ListMixin.find(4).destroy
    assert_equal [2, 1], ListMixin.find(:all, :conditions => {:parent_id => 5000}, :order => 'pos').map(&:id)
    assert_equal 1, ListMixin.find(2).pos
    assert_equal 2, ListMixin.find(1).pos
  end
  
end
