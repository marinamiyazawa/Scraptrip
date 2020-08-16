class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  attachment :image

  def partner(user)
    # 自分以外のエントリーを返す
    if user == entries.first.user
      entries.second.user
    else
      entries.first.user
    end
  end
end
