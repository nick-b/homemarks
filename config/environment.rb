# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_homemarks_session',
    :secret      => '69385742936eae182b454ab0a7a72a5f79386f2f67d67ee19596ba3e85a2d36baf06d531b2448c145b21bae3bd72d868073ef7c6ef65b3bb85a13f18e7827de9'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end




# -------------------------------------------------------------------------------------------------------------------------
# Include your application configuration below
# -------------------------------------------------------------------------------------------------------------------------

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.server_settings = { 
  :address => "mail.foobar.com", 
  :domain => "server.foobar.com",
  :authentication => :login, 
  :user_name => "", 
  :password => "" 
  }

require 'auth_system'
require 'cache_masters'
# Homemarks overrides to rails core features, stored in /lib directory
# require 'rails_overrides'


# -------------------------------------------------------------------------------------------------------------------------
# This is used to reset the demo user account. Sets a SKIPTHIS to bypass some other stuff.
# -------------------------------------------------------------------------------------------------------------------------

if ENV['SKIPTHIS'] == 'true'
  require 'utilities/copy_user'
end


# -------------------------------------------------------------------------------------------------------------------------
# UUID Generator Configuration
# -------------------------------------------------------------------------------------------------------------------------

unless ENV['SKIPTHIS'] == 'true'
  require 'UUID'
  UUID.setup
  UUID.config(:state_file => File.join(RAILS_ROOT, "config", "uuid.state"))
end


class HmConfig
  @@property = {
    :app => {
      :salt                 => 'ase282193kkwdsfdsfjASDfe829234348',
      :email_from           => '',
      :admin_email          => '',
      :url                  => '',
      :name                 => 'HomeMarks',
      :dotcom               => 'HomeMarks.com',
      :token_life           => 1.day,
      :delayed_delete_days  => 3
      },
    :js => {
      :prototype            => 'javascripts/prototype_min.js',
      :effects              => 'javascripts/effects_min.js',
      :app                  => 'javascripts/bookmarklet_min.js'
      },
    :demo => {
      :id                   => '',
      :email                => '',
      :token                => ''
      }
    }
  cattr_accessor :property
  def self.method_missing(method, *arguments)
    HmConfig.property[method.to_sym]
  end
end


# -------------------------------------------------------------------------------------------------------------------------
# Setting up streamlined js files for use with the bookmarklet code.
# -------------------------------------------------------------------------------------------------------------------------

unless ENV['SKIPTHIS'] == 'true'
  require 'jsmin'
  JsMin.optimize('prototype.js')
  JsMin.optimize('effects.js')
  JsMin.optimize('bookmarklet.js')  
end





