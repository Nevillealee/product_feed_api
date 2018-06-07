class CreateVariants < ActiveRecord::Migration[5.1]
  def change
    create_table :variants, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :title, null: true
      t.string :option1, null: true
      t.string :sku, null: true
      t.string :position, null: true
      t.string :price, null: true
      t.string :barcode, null: true
      t.string :compare_at_price, null: true
      t.string :fulfillment_service, null: true
      t.bigint :image_id, null: true
      t.bigint :grams, null: true
      t.string :inventory_management, null: true
      t.string :inventory_policy, null: true
      t.string :inventory_quantity, null: true
      t.string :weight_unit, null: true
      t.bigint :product_id, null: true
      t.datetime :created_at, null: true
      t.datetime :updated_at, null: true
      t.belongs_to :product, index: true, foreign_key: true
    end
  end
end
