class VisionImage < ApplicationRecord
  attachment :image
  has_many :tags, dependent: :destroy
  has_many :landmarks, dependent: :destroy

  validates :image, presence: true
end
