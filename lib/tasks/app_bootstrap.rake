namespace :app do
  
  task :bootstrap => :setup do
    Debugger.start
    say "Bootstrapping HomeMarks..."
    puts
    say "1) Create your database.yml config file."
    say "2) Load the database schema."
    say "3) Setup the application database."
    puts
    %w(database_config database_schema app_specific finished).each do |task|
      Rake::Task["app:#{task}"].invoke
    end
  end

  task :database_config do
    db_config = "config/database.yml"
    db_config = File.readlink(db_config) if File.symlink?(db_config)
    if File.exist?(db_config)
      say "It looks like you already have a database.yml file."
      @restart = agree("Would you like to CLEAR it and start over? [y/n]")
    end
    unless !@restart && File.exist?(db_config)
      cp 'config/database.sample.yml', db_config
      say "I have copied database.sample.yml over. It is configured to use SQLite."
    end
    puts
  end

  task :database_schema do
    unless agree("Now it's time to load the database schema. \nAll of your data will be OVERWRITTEN. Are you sure you wish to continue? [y/n]")
      raise "Cancelled"
    end
    puts
    mkdir_p File.join(RAILS_ROOT, 'log')
    Rake::Task['environment'].invoke
    begin
      say "Attempting to reset the database."
      
      
      # silence_warnings { RAILS_ENV = 'development' }
      # Rake::Task['db:reset'].invoke
      # silence_warnings { RAILS_ENV = 'production' }
      # Rake::Task['db:reset'].invoke
    rescue
      say "rake db:reset failed, you should look into that."
      puts $!.inspect
      say "If this doesn't work, create your database manually and re-run this app:bootstrap task."
      say "At any rate, I'm going to attempt to load the schema."
      Rake::Task['db:schema:load'].invoke
    end
    Rake::Task["tmp:create"].invoke
    puts
  end

  task :app_specific do
    # rake secret
  end

  task :finished do
    say '=' * 80
    puts
    say "Your HomeMarks app is ready to roll."
    say "Now start the application with your server of choice and get bookmarking!"
    Rake::Task["db:test:clone"].invoke
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
    @restart  = false
    class << self
      extend Forwardable
      def_delegators :@terminal, :agree, :ask, :choose, :say
    end
  end
  
end

