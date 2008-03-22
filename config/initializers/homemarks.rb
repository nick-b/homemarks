
# Setting up the UUID state file and logger:
# -----------------------------------------------------------------------
UUID.state_file = File.join(RAILS_ROOT, "config", "uuid.state")
UUID.setup unless File.exists?(UUID.state_file)
UUID.config :logger => RAILS_DEFAULT_LOGGER


# Setting up streamlined js files for use with the bookmarklet code.
# -----------------------------------------------------------------------
unless ENV['SKIPTHIS'] == 'true'
  JsMin.optimize('prototype.js')
  JsMin.optimize('effects.js')
  JsMin.optimize('bookmarklet.js')  
end


