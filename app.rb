require 'sinatra'
require 'active_record'
require 'dotenv'
require 'csv'
Dotenv.load
require 'action_view'
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }
set :database_file, "./config/database.yml"
ActiveRecord::Base.establish_connection("#{ENV['DATABASE_URL']}")
# generate txt file with products in it
# save it into text dir and then
# return it in api endpoint
 get '/' do
  ProductFeed.new.write_txt
  send_file 'text/product_feed.txt'
 end
class ProductFeed
  include ActionView::Helpers::SanitizeHelper
  def write_txt
 File.delete('./text/product_feed.txt') if File.exist?('./text/product_feed.txt')
 File.open('./text/product_feed.txt', 'w') { |file| file.write("PJN_PRODUCT_FEED_BASIC \n") }
 CSV.open(
   "/home/neville/Desktop/fam_brands/product_feed_app/text/product_feed.txt",
   "ab",
   {:col_sep => "\t", :write_headers => 'false'}) do |csv|

  feed_data = Product.find_by_sql("
    select p.title,
    p.image,
    p.body_html,
    p.handle,
    p.tags,
    p.vendor,
    p.product_type,
    v.sku,
    v.price
    from products p
    inner join variants v
    ON p.id = CAST(v.product_id as BIGINT)
    WHERE p.image IS NOT NULL AND v.sku NOT LIKE '%-%' AND v.sku <> '' AND p.title not like '%Auto renew%';")

   feed_data.each do |prod|
     # initalize variables with default nil values
     # change if elses to switch statement
     destination_url = "https://www.ellie.com/products/#{prod['handle']}"
     if prod['tags'] != ""
       mytag = prod['tags']
     else
       mytag = nil
     end

     if prod['product_type'] == ""
       my_type = nil
     else
       my_type = prod['product_type']
     end

     if prod['body_html'] != ""
       no_html_str = strip_tags(prod['body_html'])
       my_description = no_html_str.gsub(/\n+/, " ").gsub('-', "").gsub(/"/, "");
       puts my_description.inspect
     else
       my_description = nil
     end

     if prod['price'] != '0.00'
       my_price = prod['price']
     else
       my_price = nil
     end

     csv << [
       prod['title'],
       prod["sku"],
       destination_url,
       prod['image']["src"],
       my_description,
       nil,
       nil, #sale price goes here aka my_price
       my_price, #should be compare_at_price
       mytag,
       prod['vendor'],
       my_type
     ]
   end
 end
end
end
# Field	| Description |	Data Type (Length)
#-------------------------------------------
# *NAME	Name	Character (255)
# *SKU	Stock keeping unit	Character (40)
# *DESTINATIONURL	Destination URL	Character (1023)
# *IMAGEURL	Image URL	Character (1023)
# *SHORTDESCRIPTION	Short description	Character (255)
# LONGDESCRIPTION	Long description	Character (1023)
# SALEPRICE	Price with discount	Number
# *PRICE	Price	Number
# *KEYWORDS	Keywords	Character (1023)
# *MANUFACTURER	Manufacturer	Character (1023)
# PRIMARYCATEGORY	Primary Category	Character (50)
# * Fields are required.
