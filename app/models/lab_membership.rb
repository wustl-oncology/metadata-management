class LabMembership < ApplicationRecord
  belongs_to :user
  belongs_to :lab

  enum :permissions, { read: 0, write: 1 }, default: :read
end
