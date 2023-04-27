module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggable_tags, as: :taggable
    has_many :tags, through: :taggable_tags
  end
end
