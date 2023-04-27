class Project < ApplicationRecord
  include Taggable
  include WithNote
  has_many :samples
end
