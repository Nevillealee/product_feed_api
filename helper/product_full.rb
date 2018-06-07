require 'httparty'
require 'dotenv/load'
require 'shopify_api'
Dir['./models/*.rb'].each {|file| require file }

module ProductAPI
  ACTIVE_PRODUCT = []

  def self.shopify_api_throttle
    ShopifyAPI::Base.site =
      "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin"
      return if ShopifyAPI.credit_left > 5
      puts "api limited reached sleeping 10.."
    sleep 10
  end

  def self.init_actives
    ShopifyAPI::Base.site =
      "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin"
    active_product_count = ShopifyAPI::Product.count
    nb_pages = (active_product_count / 250.0).ceil

    # Initalize ACTIVE_PRODUCT with all active products from Ellie.com
    1.upto(nb_pages) do |page| # throttling conditon
      ellie_active_url =
        "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin/products.json?limit=250&page=#{page}"
      @parsed_response = HTTParty.get(ellie_active_url)

      ACTIVE_PRODUCT.push(@parsed_response['products'])
      p "active products set #{page} loaded, sleeping 3"
      sleep 3
    end
    p 'active products initialized'

    ACTIVE_PRODUCT.flatten!
  end

  def self.active_to_db
    init_actives

    ACTIVE_PRODUCT.each do |current|
      prod = Product.create!(
        id: current['id'],
        title: current['title'],
        body_html: current['body_html'],
        vendor: current['vendor'],
        product_type: current['product_type'],
        handle: current['handle'],
        template_suffix: current['template_suffix'],
        published_scope: current['published_scope'],
        tags: current['tags'],
        images: current['images'],
        image: current['image'],
        created_at: current['created_at'],
        updated_at: current['updated_at'])
      current['variants'].each do |current_variant|
        Variant.create!(
        id: current_variant['id'],
        product_id: prod.id,
        title: current_variant['title'],
        option1: current_variant['option1'],
        sku: current_variant['sku'],
        price: current_variant['price'],
        barcode: current_variant['barcode'],
        compare_at_price: current_variant['compare_at_price'],
        fulfillment_service: current_variant['fulfillment_service'],
        position: current_variant['position'],
        grams: current_variant['grams'],
        image_id: current_variant['image_id'],
        inventory_management: current_variant['inventory_management'],
        inventory_policy: current_variant['inventory_policy'],
        inventory_quantity: current_variant['inventory_quantity'],
        weight_unit: current_variant['weight_unit'])
      end
      current['options'].each do |current_option|
        Option.create!(
        id: current_option['id'],
        product_id: prod.id,
        name: current_option['name'],
        position: current_option['position'],
        values: current_option['values'],
        images: current_option['images'],
        image: current_option['image'])
      end
      p "saved #{current['title']}"
    end
    p 'Active products saved succesfully'
  end
end
