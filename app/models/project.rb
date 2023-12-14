class Project < ApplicationRecord
  include Taggable
  include WithNote
  has_and_belongs_to_many :samples
  belongs_to :user
  belongs_to :lab

  validates :name, uniqueness: { message: 'must be unique' }
  validates :lab, :name, presence: { message: 'is required' }

  def self.ransackable_attributes(auth_object = nil)
    ["name", "tags", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ['samples', 'tags', 'user', 'lab']
  end
end
