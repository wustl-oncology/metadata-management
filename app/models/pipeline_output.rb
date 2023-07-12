class PipelineOutput < ApplicationRecord
  include Taggable
  include WithNote
  belongs_to :project
  belongs_to :user
  has_and_belongs_to_many :sequencing_products
end
