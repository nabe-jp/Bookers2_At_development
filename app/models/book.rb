class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  # 閲覧数
  has_many :read_counts, dependent: :destroy

  
  validates :title, :body, presence: true   # 空でない
  validates :body, length: { maximum: 200 }    # 最大200文字


  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  
  # いいね機能、idがFavoritesテーブル内に存在するかを調べる、存在すればtrue
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end