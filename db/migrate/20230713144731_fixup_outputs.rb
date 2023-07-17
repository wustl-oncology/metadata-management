class FixupOutputs < ActiveRecord::Migration[7.0]
  def change
    remove_column :pipeline_outputs, :run_id
    add_column :pipeline_outputs, :data_location, :text, null: false, index: true
  end
end
