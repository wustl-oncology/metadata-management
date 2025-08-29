# frozen_string_literal: true

class Pipeline < ApplicationRecord
  validates :name, presence: true
  validates :platform, presence: true, inclusion: { in: PlatformConstraints::PLATFORMS }
  validates :name, uniqueness: { scope: :platform }
end
