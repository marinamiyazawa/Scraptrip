class Post < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'

  enum status: { draft: 0, published: 1 }
  has_many :favorites, dependent: :destroy
  # 画像複数投稿
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image
  # hash_tag
  has_many :post_hashtag, dependent: :destroy
  has_many :hashtags, through: :post_hashtag
  belongs_to :genre, optional: true
  # google_map
  geocoded_by :title
  after_validation :geocode
  # clip(ブックマーク)
  has_many :clips, dependent: :destroy

  # バリデーション
  validates :title, presence: true
  validates :body, presence: true
  validates :rate, presence: true
  validates :genre_id, presence: true
  validates :genre, presence: true, if: -> { genre_id.present? }
  validates :post_images_images, presence: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # ハッシュタグ
  after_create do
    post = Post.find_by(id: id)
    hashtags = body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      # ハッシュタグは先頭の'#'を外した上で保存
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      PostHashtag.create(post_id: post.id, hashtag_id: tag.id)
    end
  end

  before_update do
    PostHashtag.where(post_id: id).destroy_all
    hashtags = body.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      PostHashtag.create(post_id: id, hashtag_id: tag.id)
    end
  end

  # ブックマーク
  def clip_by?(user)
    clips.where(user_id: user.id).exists?
  end
end
