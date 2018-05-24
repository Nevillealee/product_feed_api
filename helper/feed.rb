require 'httparty'
require 'dotenv/load'
require 'shopify_api'
Dir['./models/*.rb'].each {|file| require file }

class Feed
  def initialize(object)
    @object = object
    @api_key = ENV['ACTIVE_API_KEY']
    @api_pw = ENV['ACTIVE_API_PW']
    @shop = ENV['ACTIVE_SHOP']
  end

  def pull
    @@obj_array = []
    myurl = "https://#{@api_key}:#{@api_pw}@#{@shop}.myshopify.com/admin"
    cap_object = @object.capitalize.to_s
    ShopifyAPI::Base.site = myurl
    count_url = "#{myurl}/#{@object}s/count.json"
    count = HTTParty.get(count_url)
    nb_pages = (count['count'] / 250.0).ceil

    1.upto(nb_pages) do |page|
      ellie_active_url = "#{myurl}/#{@object}s.json?limit=250&page=#{page}"
      parsed_response = HTTParty.get(ellie_active_url)
      @@obj_array.push(parsed_response["#{@object}s"])
      p "active #{@object}s set #{page} loaded, sleeping 3"
      sleep 3
    end
    p "active #{@object}s initialized"
    @@obj_array.flatten!
  end

  def download
    self.pull
    @@obj_array.each do |current|
      begin
        Product.create(
        title: current['title'],
        id: current['id'],
        body_html: current['body_html'],
        vendor: current['vendor'],
        product_type: current['product_type'],
        handle: current['handle'],
        template_suffix: current['template_suffix'] || '',
        published_scope: current['published_scope'],
        tags: current['tags'],
        images: current['images'],
        variants: current['variants'],
        options: current['options'],
        image: current['image'],
        created_at: current['created_at'],
        updated_at: current['updated_at'])
      rescue
        puts "error with #{current['title']}"
        next
      end
    end
    puts "Processs complete.."
  end

end
