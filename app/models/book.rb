class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  # 閲覧数
  has_many :read_counts, dependent: :destroy

  
  validates :title, :body, :tag, presence: true       # 空でない
  validates :body, length: { maximum: 200 }           # 最大200文字


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

  # 投稿数のスコープ
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日1日で作成した全Bookを取得
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 昨日1日で作成した全Bookを取得
  # 6日前の0:00から今日の23:59までに作成した 全Bookを取得します。
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  # 2週間前の0:00から1週間前の23:59までに作成した 全Bookを取得します。
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
  
  # 7日分の投稿数、グラフに使用
  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) }  # 2日前に作成した全Bookを取得
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) }  # ...
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) }  # ...
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) }  # ...
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) }  # 6日前に作成した全Bookを取得

  # 本の一覧表で並び替えに使用
  scope :latest, -> {order(created_at: :desc)}  # 最新のものから順に並べる
  scope :old, -> {order(created_at: :asc)}      # 古いものから順に並べる
  scope :star_count, -> {order(star: :desc)}    # 星の数が多いものから順に並べる


  # いいね機能、idがFavoritesテーブル内に存在するかを調べる、存在すればtrue
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end