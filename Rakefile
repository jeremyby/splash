
require 'active_record'
require './splash'
require 'sinatra/activerecord/rake'

 
task(:environment) do
  env = ENV["RACK_ENV"] ? ENV["RACK_ENV"] : "development"
  ActiveRecord::Base.establish_connection(YAML::load_file('database.yml')[env])
end
 
task(:migrate => :environment) do
  ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
end
