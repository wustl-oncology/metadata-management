class PipelineOutput < ApplicationRecord
  include Taggable
  include WithNote
  belongs_to :project
  belongs_to :user
  has_and_belongs_to_many :sequencing_products

  def self.ransackable_attributes(auth_object = nil)
    [
      "pipeline_name",
      "pipeline_version",
      "platform",
      "platform_identifier",
      "data_location",
      "created_at",
      "updated_at",
      "user",
      "project",
      "tags",
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ['sequencing_products', 'tags', 'project', 'user']
  end

  def display_name
    data_location
  end
end
