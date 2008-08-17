require 'tempfile'
require 'rubygems'
require 'active_support'


class HmConfig
  @@property = {
    :app => {
      :email_from           => 'ken@homemarks.com',
      :admin_email          => 'ken@homemarks.com',
      :host                 => 'dev.homemarks.com',
      :delayed_delete_days  => 3,
      :cookie_secret        => 'edd44bca0fe498336609eaf80054c2122259e0'
    },
    :demo => {
      :id                   => '',
      :email                => '',
      :token                => ''
    }
  }
  cattr_accessor :property
  def self.method_missing(method, *arguments)
    self.property[method.to_sym]
  end
end


