class AddNotesToSamples < ActiveRecord::Migration[7.0]
  def change
    add_column :samples, :notes, :text
  end
end
