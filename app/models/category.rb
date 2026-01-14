# 分类模型
# 用于对书籍进行分类管理
class Category < ApplicationRecord
  # 关联书籍，当分类被删除时，书籍的分类ID设为null
  has_many :books, dependent: :nullify

  # 验证分类名称不能为空且唯一
  validates :name, presence: true, uniqueness: true
end
