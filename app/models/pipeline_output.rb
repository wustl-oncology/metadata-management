class PipelineOutput < ApplicationRecord
  include Taggable
  belongs_to :project
  has_and_belongs_to_many :sequencing_products
end
