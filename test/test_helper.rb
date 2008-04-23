ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

ActionController::TestCase.send :include, ERB::Util

class Test::Unit::TestCase
  
  include AuthenticatedTestHelper
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  self.new_backtrace_silencer(:shoulda) { |line| line.include? 'vendor/plugins/shoulda' }
  self.new_backtrace_silencer(:mocha) { |line| line.include? 'vendor/plugins/mocha' }
  self.new_backtrace_silencer(:vendor_rails) { |line| line.include? 'vendor/rails' }
  self.backtrace_silencers << :shoulda << :mocha << :vendor_rails
  
  fixtures :all
  
  
  protected
  
  def should_have_site_navigation(logged_in=false)
    standard_nav_names = /Home|Help/
    stateful_nav_names = logged_in ? /My HomeMarks|Logout/ : /Login/
    all_nav_names      = Regexp.union(standard_nav_names,stateful_nav_names)
    navigation_count   = logged_in ? 4 : 3
    assert_select '#site_links a', { :count => navigation_count, :text => all_nav_names }
    assert_select '#site_links a' do
      assert_select 'img', true, 'should have an image tag inside all nav items'
      assert_select 'img[alt=?]', all_nav_names
    end
  end
  
  
end

