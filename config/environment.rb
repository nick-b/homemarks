
# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
require 'digest/sha1'

Rails::Initializer.run do |config|
  config.frameworks  -= [ :active_resource ]
  config.load_paths  += [ "#{RAILS_ROOT}/app/sweepers" ]
  config.action_controller.session = {
    :session_key      => '_myhomemarks_session',
    :secret           => HmConfig.app[:cookie_secret]
  }
  config.active_record.observers = :user_observer
  config.active_record.partial_updates  = true
  config.active_record.default_timezone = :utc
  config.action_controller.cache_store  = :file_store, "#{Dir.tmpdir}/com.homemarks"
  config.time_zone = 'UTC'
end


ActionMailer::Base.delivery_method = :sendmail



