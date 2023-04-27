class SequencingProduct < ApplicationRecord
  include Taggable
  has_and_belongs_to_many :pipeline_outputs
  belongs_to :sample
end
