class User < ApplicationRecord
  #  encrypts :api_key, deterministic: true

  validates :api_key, uniqueness: true
  validates :github_uid, uniqueness: true
  validates :name, uniqueness: true
  # validates :email, uniqueness: true

  before_create :generate_api_key

  has_many :projects
  has_many :pipeline_outputs
  has_many :lab_memberships, dependent: :destroy
  has_many :writable_lab_memberships,
           -> { where(permissions: 'write') },
           class_name: 'LabMembership'
  has_many :labs, through: :lab_memberships

  def self.ransackable_attributes(_auth_object = nil)
    %i[id created_at updated_at]
  end

  def self.get_or_create_from_omniauth(auth_hash)
    email = auth_hash.dig('extra', 'raw_info', 'email'),

            user = User.where(
              name: auth_hash.dig('extra', 'raw_info', 'login'),
              github_uid: auth_hash['uid']
            ).first_or_create!

    if email.present? && email != user.email
      user.email = email
      user.save!
    end

    user
  end

  def generate_api_key(force: false)
    return unless api_key.blank? || force

    self.api_key = SecureRandom.hex
  end
end
