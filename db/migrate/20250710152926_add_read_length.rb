class AddReadLength < ActiveRecord::Migration[7.1]
  def change
    add_column :sequencing_products, :read_length, :integer
  end
end
