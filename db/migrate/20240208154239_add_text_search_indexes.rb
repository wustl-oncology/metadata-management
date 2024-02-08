class AddTextSearchIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :projects, %{to_tsvector('english', name)}, using: :gin
    add_index :samples, %{to_tsvector('english', name)}, using: :gin
    add_index :pipeline_outputs, %{to_tsvector('english', data_location)}, using: :gin
    add_index :sequencing_products, %{to_tsvector('english', unaligned_data_path)}, using: :gin

    add_index :projects, :name, using: :gist, opclass: :gist_trgm_ops, name: 'idx_project_name_tri'
    add_index :samples, :name, using: :gist, opclass: :gist_trgm_ops, name: 'idx_sample_name_tri'
    add_index :pipeline_outputs, :data_location, using: :gist, opclass: :gist_trgm_ops, name: 'idx_po_location_tri'
    add_index :sequencing_products, :unaligned_data_path, using: :gist, opclass: :gist_trgm_ops, name: 'idx_sp_data_path_tri'
  end
end
