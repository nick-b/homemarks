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
      :cookie_secret        => '___pleasechangeme___'
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


