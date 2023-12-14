class Permissions < ActiveRecord::Migration[7.1]
  def change
    create_table :labs do |t|
      t.text :name, null: false
      t.timestamps
    end

    add_column :users, :admin, :boolean, default: false, null: false

    add_column :projects, :lab_id, :integer
    add_foreign_key :projects, :labs

    remove_column :projects, :lab

    create_table :lab_memberships do |t|
      t.references :user, null: false
      t.references :lab, null: false
      t.integer :permissions, null: false
      t.timestamps
    end

    add_foreign_key :lab_memberships, :labs
    add_foreign_key :lab_memberships, :users

  end
end
