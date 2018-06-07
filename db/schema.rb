# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_30_153428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "options", force: :cascade do |t|
    t.bigint "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "values"
    t.string "images"
    t.string "image"
    t.integer "position"
    t.index ["product_id"], name: "index_options_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "body_html"
    t.string "vendor"
    t.string "product_type"
    t.string "handle"
    t.string "template_suffix"
    t.string "published_scope"
    t.jsonb "images"
    t.jsonb "image"
    t.string "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variants", force: :cascade do |t|
    t.string "title"
    t.string "option1"
    t.string "sku"
    t.string "position"
    t.string "price"
    t.string "barcode"
    t.string "compare_at_price"
    t.string "fulfillment_service"
    t.bigint "image_id"
    t.bigint "grams"
    t.string "inventory_management"
    t.string "inventory_policy"
    t.string "inventory_quantity"
    t.string "weight_unit"
    t.bigint "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "options", "products"
  add_foreign_key "variants", "products"
end
