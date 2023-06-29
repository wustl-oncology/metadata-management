class RemoveTimepoint < ActiveRecord::Migration[7.0]
  def change
    remove_column :sequencing_products, :timepoint
  end
end
