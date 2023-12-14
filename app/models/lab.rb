class Lab < ApplicationRecord
  validates :name, uniqueness: { message: 'must be unique' }
  validates :name, :name, presence: { message: 'is required' }

  has_many :lab_memberships
  has_many :lab_members, through: :lab_memberships, source: :user

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
