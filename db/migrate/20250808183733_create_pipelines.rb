class CreatePipelines < ActiveRecord::Migration[7.1]
  def change
    create_table :pipelines do |t|
      t.string :name, null: false
      t.string :platform, null: false

      t.timestamps

      t.index %i[name platform], unique: true
    end
  end
end
