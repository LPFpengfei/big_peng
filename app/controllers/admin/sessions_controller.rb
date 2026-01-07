class Admin::SessionsController < ApplicationController
  layout "admin"
  skip_before_action :require_admin_login, only: [ :new, :create ]

  def new
    # 登录页面
  end

  def create
    admin = Admin.find_by(email: params[:email])

    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_admins_path, notice: "登录成功"
    else
      flash.now[:alert] = "邮箱或密码错误"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to admin_login_path, notice: "已退出登录"
  end
end
