class AddNotesToPipelineOutputs < ActiveRecord::Migration[7.0]
  def change
    add_column :pipeline_outputs, :notes, :text
  end
end
