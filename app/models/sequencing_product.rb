class SequencingProduct < ApplicationRecord
  include Taggable
  include WithNote
  has_and_belongs_to_many :pipeline_outputs
  belongs_to :sample

  def self.from_upload_row(row)
    SequencingProduct.new(
      library_prep: row['Library Prep'],
      instrument: row['Instrument'],
      unaligned_data_path: row['Unaligned Data Path'],
      flow_cell_id: row['Flow Cell ID']
    )
  end

  def self.ransackable_attributes(auth_object = nil)
    ["library_prep", "flow_cell_id", "instrument", "unaligned_data_path", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ['sample', 'tags']
  end
end
