class Tag < ApplicationRecord
  has_many :taggable_tags
  #TODO - do we want to create the rest of these?
  has_many :samples, through: :taggable_tags, source_type: 'Sample'

  def self.ransackable_attributes(auth_object = nil)
    ["tag"]
  end
end
