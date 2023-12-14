class LabMembership < ApplicationRecord
  belongs_to :user
  belongs_to :lab

  enum permissions: [:read, :write], _default: :read
end
