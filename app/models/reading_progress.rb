# 阅读进度模型
# 记录用户的阅读进度，包括章节和页码
class ReadingProgress < ApplicationRecord
  # 关联用户
  belongs_to :user
  # 关联书籍
  belongs_to :book

  # 唯一性验证：一个用户对一本书只能有一个阅读进度
  validates :user_id, uniqueness: { scope: :book_id, message: "这本书的阅读进度已经存在" }
  # 验证章节不能为空
  validates :chapter, presence: true
  # 验证页码不能为空且必须大于等于1
  validates :page, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
