class Upload < ApplicationRecord
  has_one_attached :sample_file
  belongs_to :project

  def self.expected_headers
    [
      'Sample Name',
      'Species',
      'Tissue',
      'Individual',
      'Timepoint',
      'Disease Status',
      'Library Prep',
      'Instrument',
      'Unaligned Data Path',
      'Flow Cell ID',
    ]
  end
end
