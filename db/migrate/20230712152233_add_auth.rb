class AddAuth < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_uid, :text, null: false, index: true
    add_column :users, :api_key, :text, null: false, index: true, unique: true
    add_reference :pipeline_outputs, :user, null: false
  end
end
