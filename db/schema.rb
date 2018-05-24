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

ActiveRecord::Schema.define(version: 2018_05_24_214550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "title", null: false
    t.string "body_html", default: ""
    t.string "vendor", null: false
    t.string "product_type", default: "", null: false
    t.string "handle"
    t.string "template_suffix"
    t.string "published_scope"
    t.jsonb "images"
    t.jsonb "image"
    t.string "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "options"
    t.string "variants"
  end

end
