
UUID.state_file = File.join(RAILS_ROOT, "tmp", "uuid.state")
UUID.setup unless File.exists?(UUID.state_file)
UUID.config :state_file => UUID.state_file, :logger => RAILS_DEFAULT_LOGGER

