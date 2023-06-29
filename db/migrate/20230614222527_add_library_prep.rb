class AddLibraryPrep < ActiveRecord::Migration[7.0]
  def change
    add_column :sequencing_products, :library_prep, :text
  end
end
