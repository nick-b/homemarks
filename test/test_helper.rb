ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  self.new_backtrace_silencer(:shoulda) { |line| line.include? 'vendor/plugins/shoulda' }
  self.new_backtrace_silencer(:mocha) { |line| line.include? 'vendor/plugins/mocha' }
  self.backtrace_silencers << :shoulda << :mocha
  
  fixtures :all
  
  
  
end
