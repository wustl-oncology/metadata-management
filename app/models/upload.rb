class Upload < ApplicationRecord
  has_one_attached :sample_file
  belongs_to :project
end
