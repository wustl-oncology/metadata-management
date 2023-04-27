class Sample < ApplicationRecord
  include Taggable
  include WithNote
  belongs_to :project
  has_many :sequencing_products
end
