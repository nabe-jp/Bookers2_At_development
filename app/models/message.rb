class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :message, length: { maximum: 140 }    # 最大140字
end
