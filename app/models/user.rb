# 用户模型
# 用于存储用户信息，包括登录凭证和个人资料
class User < ApplicationRecord
  # 使用bcrypt加密密码
  has_secure_password

  # 关联书架记录
  has_many :bookshelves, dependent: :destroy
  # 关联书签记录
  has_many :bookmarks, dependent: :destroy
  # 关联阅读进度记录
  has_many :reading_progresses, dependent: :destroy
  # 通过书架关联书籍
  has_many :books, through: :bookshelves

  # 验证邮箱不能为空、唯一且格式正确
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # 验证昵称不能为空
  validates :nickname, presence: true
  # 验证密码长度至少为6个字符（仅在创建时验证）
  validates :password, length: { minimum: 6 }, on: :create
end
