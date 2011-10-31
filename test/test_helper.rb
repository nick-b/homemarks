ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'homemarks_test_helper'

class Test::Unit::TestCase

  include ERB::Util
  include AuthenticatedTestHelper
  include HomemarksTestHelper

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  self.new_backtrace_silencer(:shoulda) { |line| line.include? 'vendor/plugins/shoulda' }
  self.new_backtrace_silencer(:mocha) { |line| line.include? 'vendor/plugins/mocha' }
  self.new_backtrace_silencer(:vendor_rails) { |line| line.include? 'vendor/rails' }
  self.backtrace_silencers << :shoulda << :mocha << :vendor_rails

  fixtures :all




end

