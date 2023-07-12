class User < ApplicationRecord

  encrypts :api_key, deterministic: true

  validates :api_key, uniqueness: true
  validates :github_uid, uniqueness: true
  validates :name, uniqueness: true
  validates :email, uniqueness: true

  before_create :generate_api_key


  def self.ransackable_attributes(auth_object = nil)
    [:id, :created_at, :updated_at]
  end

  def self.get_or_create_from_omniauth(auth_hash)
    User.where(
      name: auth_hash.dig('extra', 'raw_info', 'login'),
      email: auth_hash.dig('extra', 'raw_info', 'email'),
      github_uid: auth_hash['uid']
    ).first_or_create!
  end

  def generate_api_key(force: false)
    if self.api_key.blank? || force
      self.api_key = SecureRandom.hex
    end
  end
end
