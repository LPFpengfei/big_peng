# 书签模型
# 记录用户在书籍中的书签位置和笔记
class Bookmark < ApplicationRecord
  # 关联用户
  belongs_to :user
  # 关联书籍
  belongs_to :book

  # 验证用户ID不能为空
  validates :user_id, presence: true
  # 验证书籍ID不能为空
  validates :book_id, presence: true
  # 验证章节不能为空
  validates :chapter, presence: true
  # 验证页码不能为空且必须大于等于1
  validates :page, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
