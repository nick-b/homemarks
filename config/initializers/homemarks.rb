
# Simple configuration class.
# -----------------------------------------------------------------------
class HmConfig
  JSMIN_TARGETS = ['prototype','effects','bookmarklet']
  @@property = {
    :app => {
      :email_from           => '',
      :admin_email          => '',
      :url                  => 'homemarks.com',  # Need request.host
      :name                 => 'HomeMarks',
      :dotcom               => 'HomeMarks.com',
      :token_life           => 1.day,
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
    HmConfig.property[method.to_sym]
  end
end


# Setting up the UUID state file and logger.
# -----------------------------------------------------------------------
UUID.state_file = File.join(RAILS_ROOT, "tmp", "uuid.state")
UUID.setup unless File.exists?(UUID.state_file)
UUID.config :state_file => UUID.state_file, :logger => RAILS_DEFAULT_LOGGER

# Setting up streamlined js files for use with the bookmarklet code.
# -----------------------------------------------------------------------
HmConfig::JSMIN_TARGETS.each { |target| JsMin.optimize("#{target}.js") }

