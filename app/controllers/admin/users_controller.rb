# 管理端用户控制器
# 处理管理员对用户的管理操作
class Admin::UsersController < ApplicationController
  layout "admin"
  skip_before_action :verify_authenticity_token
  before_action :require_admin_login
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  # 用户列表
  # GET /admin/users
  def index
    @users = User.all.order(created_at: :desc).page(params[:page])
    @user = User.new
  end

  # 用户详情
  # GET /admin/users/:id
  def show
    # 获取用户的书架和阅读记录
    @bookshelves = @user.bookshelves.includes(:book).order(created_at: :desc)
    @bookmarks = @user.bookmarks.includes(:book).order(created_at: :desc)
    @reading_progresses = @user.reading_progresses.includes(:book).order(updated_at: :desc)
  end

  # 新建用户页面
  # GET /admin/users/new
  def new
    @user = User.new
    render :form, layout: false
  end

  # 创建用户
  # POST /admin/users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { success: true, message: "用户创建成功" }
    else
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 编辑用户页面
  # GET /admin/users/:id/edit
  def edit
    render :form, layout: false
  end

  # 更新用户
  # PUT /admin/users/:id
  def update
    if @user.update(user_params)
      render json: { success: true, message: "用户更新成功" }
    else
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 删除用户
  # DELETE /admin/users/:id
  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "用户已删除"
  end

  private

  # 设置用户
  def set_user
    @user = User.find(params[:id])
  end

  # 用户参数白名单
  def user_params
    params.require(:user).permit(:email, :nickname, :password, :password_confirmation)
  end
end
