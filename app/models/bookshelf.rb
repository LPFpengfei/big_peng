# 书架模型
# 记录用户与书籍的关联关系，即用户的书架
class Bookshelf < ApplicationRecord
  # 关联用户
  belongs_to :user
  # 关联书籍
  belongs_to :book

  # 唯一性验证：一个用户对一本书只能添加一次到书架
  validates :user_id, uniqueness: { scope: :book_id, message: "这本书已经在你的书架中了" }
end
