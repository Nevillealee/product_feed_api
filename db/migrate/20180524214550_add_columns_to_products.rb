class AddColumnsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :options, :string
    add_column :products, :variants, :string
  end
end
