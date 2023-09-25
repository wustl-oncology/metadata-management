class AdditionalFields < ActiveRecord::Migration[7.0]
  def change
    add_column :sequencing_products, :strand, :text
    add_column :sequencing_products, :kit, :text
    add_column :sequencing_products, :targeted_capture, :text
    add_column :sequencing_products, :paired_end, :text
    add_column :sequencing_products, :batch, :text
  end
end
