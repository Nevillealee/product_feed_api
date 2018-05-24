require 'sinatra'
require 'active_record'
require 'dotenv'
require 'csv'
Dotenv.load
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }
set :database_file, "./config/database.yml"
ActiveRecord::Base.establish_connection("#{ENV['DATABASE_URL']}")
# generate txt file with products in it
# save it into text dir and then
# return it in api endpoint
 get '/' do
  write_json
  send_file 'text/product_feed.txt'
 end

 def write_json
   # time = Time.now.strftime("%b%d%Y_%I%M")
   File.delete('./text/product_feed.txt') if File.exist?('./text/product_feed.txt')
   File.open('./text/product_feed.txt', 'w') { |file| file.write("PJN_PRODUCT_FEED_BASIC") }
   CSV.open("/home/neville/Desktop/fam_brands/product_feed_app/text/product_feed.txt", "ab", {:col_sep => " ", :skip_blanks => 'true', :write_headers => 'false' }) do |csv|
     Product.all.each do |prod|
       # prod.attributes.values
       if prod.images && prod.variants
       csv << [
         prod.title,
         # prod.variants[0]["sku"],
         "https://www.ellie.com/products/#{prod.handle}",
         # prod.images[0]["src"],
         # prod.variants[0]["price"],
         prod.tags,
         prod.vendor
       ]
     end
     end
  end
end
