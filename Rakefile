require 'dotenv'
Dotenv.load
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './app'
Dir['./helper/*.rb'].each {|file| require file }


namespace :shopify do
  desc "pulls down passed in obj (singular) from ellie.com"
  task :download, [:args] do |t, args|
    myfeed = Feed.new(*args)
    myfeed.download
  end

  desc "pulls products, variants, and options"
  task :product_pull do
    if Product.exists?
      ActiveRecord::Base.connection.execute("TRUNCATE products CASCADE;")
      ProductAPI.active_to_db
    else
      ProductAPI.active_to_db
    end
  end
end
