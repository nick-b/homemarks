
# Simple configuration class.
# -----------------------------------------------------------------------

class HmConfig
  @@property = {
    :app => {
      :email_from           => 'ken@homemarks.com',
      :admin_email          => 'ken@homemarks.com',
      :host                 => 'dev.homemarks.com',
      :delayed_delete_days  => 3
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


# Setting up the UUID state file and logger.
# -----------------------------------------------------------------------

UUID.state_file = File.join(RAILS_ROOT, "tmp", "uuid.state")
UUID.setup unless File.exists?(UUID.state_file)
UUID.config :state_file => UUID.state_file, :logger => RAILS_DEFAULT_LOGGER


