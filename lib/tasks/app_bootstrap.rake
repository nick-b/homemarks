namespace :app do
  
  task :bootstrap => :setup do
    Debugger.start
    say "Bootstrapping HomeMarks..."
    puts
    say "1) Create your database.yml config file."
    say "2) Create your SQLite databases."
    say "3) Load the database schema."
    say "4) Create your local HomeMarks account."
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
      say "You should probablly configure things from here on out!"
      raise "Cancelled!"
    else
      cp 'config/database.sample.yml', db_config
      say "STEP #1) I have copied database.sample.yml over."
    end
    puts
  end

  task :database_schema do
    say "=" * 80
    say "Now it's time to load the database schema."
    say "All of your data will be OVERWRITTEN."
    say "=" * 80
    unless agree("Are you sure you wish to continue? [y/n]")
      raise "Cancelled!"
    end
    puts
    Rake::Task['environment'].invoke
    begin
      say "STEP #2) Attempting to create the SQLite databases."
      puts
      Rake::Task['db:create:all'].invoke
      puts
      say "STEP #3) Loading the schema into both development and production DBs."
      puts
      silence_warnings { RAILS_ENV = 'development' }
      Rake::Task['db:schema:load'].invoke
      silence_warnings { RAILS_ENV = 'production' }
      Rake::Task['db:schema:load'].invoke
    rescue
      say "Something went wrong. You should look into that."
      puts $!.inspect
    end
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

