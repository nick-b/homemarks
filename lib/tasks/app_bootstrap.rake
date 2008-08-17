
namespace :app do
  
  task :bootstrap => :setup do
    Debugger.start
    puts
    say "Bootstrapping HomeMarks. The following will happen:"
    puts
    say "  1) Gather app specific information."
    say "  2) Create your database.yml config file."
    say "  3) Initialize and configuring the application."
    say "  4) Create your SQLite3 databases with full schema."
    say "  5) Create your HomeMarks account."
    puts
    say "WARNING: THESE TASKS WILL DESTROY EXISTING DATA!!!!"
    unless agree("Are you sure you wish to continue? [y/n]")
      raise "Cancelled!"
    end
    puts
    ['gather_info','copy_dbyml','init_app','setup_databases','create_user','finished'].each do |task|
      Rake::Task["app:#{task}"].invoke
    end
  end
  
  task :gather_info do
    say "STEP #1) Enter application specific information:"
    say "         The host/port is very important for some app resources. It is suggested that"
    say "         you use a FQDN with real DNS or something that is setup in your hosts file."
    puts
    @app_host       = ask("         What host/port to use:  ") { |q| q.default = '0.0.0.0:3000' }
    @user_email     = ask("           Email for HomeMarks:  ") { |q| q.validate = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
    @user_password  = ask("        Password for HomeMarks:  ") { |q| q.echo = "x" ; q.validate = /^.{4,40}$/i }
    @user_password2 = ask("              Confirm password:  ") { |q| q.echo = "x" }
    unless @user_password == @user_password2
      raise "Passwords do not match!"
    end
    puts
  end
  
  task :copy_dbyml do
    db_config = "config/database.yml"
    db_config = File.readlink(db_config) if File.symlink?(db_config)
    if File.exist?(db_config)
      say "It looks like you already have a database.yml file."
      say "You should probablly configure things from here on out!"
      raise "Cancelled!"
    else
      cp 'config/database.sample.yml', db_config
      say "STEP #2) The database.yml from sample has been copied over."
    end
    puts
  end
  
  task :init_app do
    say "STEP #3) Initialize and configuring the application."
    init_file = 'config/preinitializer.rb'
    init_file_data = File.read(init_file)
    css_file = 'public/stylesheets/bookmarklet.css'
    css_file_data = File.read(css_file)
    say "         Generating new secret for cookie store into HmConfig..."
    secret = Rails::SecretKeyGenerator.new('HomeMarks').generate_secret
    init_file_data.sub! 'edd44bca0fe498336609eaf80054c2122259e0', secret
    say "         Updating HmConfig and CSS configuration info..."
    init_file_data.gsub! 'dev.homemarks.com', @app_host
    css_file_data.gsub!  'dev.homemarks.com', @app_host
    init_file_data.gsub! 'ken@homemarks.com', @user_email
    File.open(init_file,'w') { |f| f.write(init_file_data) }
    File.open(css_file,'w')  { |f| f.write(css_file_data) }
    say "         Creating UUID state file..."
    Rake::Task['environment'].invoke
    puts
  end
  
  task :setup_databases do
    begin
      say "STEP #4) Creating your SQLite3 databases with full schema."
      ActiveRecord::Schema.verbose = false
      ['test','production','development'].each do |env|
        ActiveRecord::Base.establish_connection(env)
        load 'db/schema.rb'
      end
    rescue
      say "Something went wrong. You should look into that."
      puts $!.inspect
    end
    puts
  end
  
  task :create_user do
    say "STEP #5) Creating HomeMarks user for <#{@user_email}>."
    @user = User.new :email => @user_email, :password => @user_password, :password_confirmation => @user_password2
    @user.verified = true
    @user.save!
    puts
  end
  
  task :finished do
    puts
    say '=' * 75
    say "Your HomeMarks installation is ready. Please use this authenticated url"
    say "to automatically log you in."
    say "http://#{@app_host}/session/jumpin?token=#{@user.security_token}"
    say '=' * 75
    puts
  end
  
  task :setup do
    require 'rubygems'
    gem 'highline'
    gem 'ruby-debug'
    require 'ostruct'
    require 'ruby-debug'
    require 'highline'
    require 'forwardable'
    @terminal = HighLine.new
    class << self
      extend Forwardable
      def_delegators :@terminal, :agree, :ask, :choose, :say
    end
  end
  
end

