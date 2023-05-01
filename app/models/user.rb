class User < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [:id, :tag, :created_at, :updated_at]
  end
end
