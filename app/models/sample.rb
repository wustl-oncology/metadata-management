class Sample < ApplicationRecord
  include Taggable
  include WithNote
  has_and_belongs_to_many :projects
  has_many :sequencing_products

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "species", "tags", "disease_status", "individual", "timepoint", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ['projects', 'tags']
  end

  def self.from_upload_row(row)
    Sample.new(
      name: row['Sample Name'],
      species: row['Species'],
      individual: row['Individual'],
      timepoint: row['Timepoint'],
      disease_status: row['Disease Status']
    )
  end

  def display_name
    name
  end
end
