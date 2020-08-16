class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  attachment :image

  validates :content, presence: true
end
