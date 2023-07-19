module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggable_tags, as: :taggable
    has_many :tags, through: :taggable_tags

    def tag!(*tags)
      tags.each do |tag|
        t = Tag.where(tag: tag).first_or_create!

        self.tags << t unless self.tags.include?(t)
      end
    end
  end
end
