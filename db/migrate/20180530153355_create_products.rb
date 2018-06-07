class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :title, null: true
      t.string :body_html, null: true
      t.string :vendor, null: true
      t.string :product_type, null: true
      t.string :handle, null: true
      t.string :template_suffix, null: true
      t.string :published_scope, null: true
      t.jsonb :images, null: true
      t.jsonb :image, null: true
      t.string :tags, null: true
      t.datetime :created_at, null: true
      t.datetime :updated_at, null: true
    end
  end
end
