class Sample < ApplicationRecord
  include Taggable
  belongs_to :project
  has_many :sequencing_products
end
