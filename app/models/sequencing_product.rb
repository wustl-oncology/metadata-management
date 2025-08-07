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
      flow_cell_id: row['Flow Cell ID'],
      strand: row['Strand'],
      kit: row['Kit'],
      targeted_capture: row['Targeted Capture'],
      paired_end: row['Paired End'],
      batch: row['Batch'],
      read_length: row['Read Length']
    )
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      library_prep
      flow_cell_id
      instrument
      unaligned_data_path
      strand
      kit
      targeted_capture
      paired_end
      batch
      read_length
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[sample tags]
  end

  def display_name
    unaligned_data_path
  end
end
