# 书籍模型
# 存储电子书的基本信息和文件路径
class Book < ApplicationRecord
  # 关联分类，分类可选
  belongs_to :category, optional: true
  # 关联书签记录，当书籍被删除时，相关书签也会被删除
  has_many :bookmarks, dependent: :destroy
  # 关联阅读进度记录，当书籍被删除时，相关阅读进度也会被删除
  has_many :reading_progresses, dependent: :destroy
  # 关联书架记录，当书籍被删除时，相关书架记录也会被删除
  has_many :bookshelves, dependent: :destroy
  # 通过书架关联用户
  has_many :users, through: :bookshelves

  # 验证书名不能为空
  validates :title, presence: true
  # 验证作者不能为空
  validates :author, presence: true
  # 验证文件路径不能为空
  validates :file_path, presence: true
  # 验证来源不能为空
  validates :source, presence: true
end
