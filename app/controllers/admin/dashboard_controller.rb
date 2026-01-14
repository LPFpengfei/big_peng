# 仪表板控制器
class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :require_admin_login

  def index
    # 统计数据
    @stats = {
      total_books: Book.count,
      total_users: User.count,
      today_visitors: rand(100..500), # 模拟数据，实际应从日志或统计系统获取
      total_admins: Admin.count
    }

    # 最近添加的书籍
    @recent_books = Book.order(created_at: :desc).limit(5)

    # 最近注册的用户
    @recent_users = User.order(created_at: :desc).limit(5)
  end
end
