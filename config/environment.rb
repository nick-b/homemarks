
# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_resource ]
  config.plugins = [ :acts_as_list, :shoulda ]
  
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  config.action_controller.session = {
    :session_key => '_myhomemarks_session',
    :secret      => '69385742936eae182b454ab0a7a72a5f79386f2f67d67ee19596ba3e85a2d36baf06d531b2448c145b21bae3bd72d868073ef7c6ef65b3bb85a13f18e7827de9'
  }
  
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  
  config.active_record.default_timezone = :utc
  config.time_zone = 'UTC'
  
end




# -------------------------------------------------------------------------------------------------------------------------
# Include your application configuration below
# -------------------------------------------------------------------------------------------------------------------------

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = { 
  :address => "mail.foobar.com", 
  :domain => "server.foobar.com",
  :authentication => :login, 
  :user_name => "", 
  :password => "" 
  }



# -------------------------------------------------------------------------------------------------------------------------
# This is used to reset the demo user account. Sets a SKIPTHIS to bypass some other stuff.
# -------------------------------------------------------------------------------------------------------------------------

if RAILS_ENV == 'test' || ENV['SKIPTHIS'] == 'true'
  require 'utilities/copy_user'
end


