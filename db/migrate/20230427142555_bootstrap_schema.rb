class BootstrapSchema < ActiveRecord::Migration[7.0]
  def change
     create_table :projects do |t|
      t.text :name, null: false, index: true
      t.text :lab, null: false, index: true
      t.text :notes, null: true
      t.timestamps
    end

   create_table :samples do |t|
      t.text :name, null: false, index: true
      t.text :species, null: false, index: true #taxon table?
      t.text :individual, null: false, index: true 
      t.text :timepoint, null: true, index: true #can this be constrained?
      t.text :disease_status, null: true, index: true #can this be constrained?
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end

    create_table :sequencing_products do |t|
      t.references :sample, null: false, foreign_key: true
      t.text :instrument, null: false, index: true
      t.text :timepoint, null: true, index: true
      t.text :flow_cell_id, null: true, index: true
      t.text :unaligned_data_path, null: false, index: true
      t.text :notes, null: true
      t.timestamps
    end

    create_table :pipeline_outputs do |t|
      t.text :run_id, null: false, index: true
      t.references :project, null: false, index: true, foreign_key: true
      t.text :pipeline_name, null: false, index: true #workflow name in terra, model type in gms?
      t.text :pipeline_version, null: false, index: true #sha? tag? dockstore relese?
      t.text :platform, null: false, index: true #terra/gcp/compute1/etc
      t.text :platform_identifier, null: false, index: true #cromwell workflow id, gms build id, etc
      t.datetime :run_completed_at, null: true
      t.timestamps
    end

    create_table :pipeline_outputs_sequencing_products do |t|
      t.integer :pipeline_output_id, null: false
      t.integer :sequencing_product_id, null: false
      t.timestamps
    end

    add_foreign_key :pipeline_outputs_sequencing_products, :pipeline_outputs, name: 'fk_pipelineoutputs_bridge'
    add_foreign_key :pipeline_outputs_sequencing_products, :sequencing_products, name: 'fk_sequenceproduct_bridge'
    add_index :pipeline_outputs_sequencing_products, :pipeline_output_id, name: 'idx_pipelineoutput_bridge'
    add_index :pipeline_outputs_sequencing_products, :sequencing_product_id, name: 'idx_sequenceproduct_bridge'


    create_table :tags do |t|
      t.text :tag, null: false, index: true
      t.text :notes, null: true
      t.timestamps
    end

    create_table :taggable_tags do |t|
      t.references :tag, null: false, index: true
      t.references :taggable, polymorphic: true, index: true, ull: false
      t.timestamps
    end

    create_table :input_bundles do |t|
      t.text :name, null: false, index: true
      t.text :path, null: false, index: true
      t.text :notes, null: true
      t.timestamps
    end

    create_table :users do |t|
      t.text :email, null: false, index: true
      t.text :name, null: false, index: true
      t.timestamps
    end
  end
end
