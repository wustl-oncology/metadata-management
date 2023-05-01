class Project < ApplicationRecord
  include Taggable
  include WithNote
  has_many :samples

  validates_uniqueness_of :name

  def self.ransackable_attributes(auth_object = nil)
    ["name", "lab", "tags", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ['samples', 'tags']
  end
end
