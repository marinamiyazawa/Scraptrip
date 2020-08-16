class Genre < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_ancestry
end
