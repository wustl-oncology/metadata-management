class SamplesCanBelongToManyProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :samples, :project_id
    create_join_table :samples, :projects
  end
end
