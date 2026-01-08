class Admin::AdminsController < ApplicationController
  layout "admin"
  before_action :require_admin_login
  before_action :set_admin, only: [ :show, :edit, :update, :destroy ]

  def index
    @admins = Admin.order(created_at: :desc).page(params[:page])
    @admin = Admin.new
  end

  def show
  end

  def new
    @admin = Admin.new
    render :form, layout: false
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      render json: { success: true, message: "管理员创建成功" }
    else
      render json: { success: false, errors: @admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    render :form, layout: false
  end

  def update
    if @admin.update(admin_params)
      render json: { success: true, message: "管理员更新成功" }
    else
      render json: { success: false, errors: @admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @admin.id == current_admin.id
      redirect_to admin_admins_path, alert: "不能删除当前登录的管理员"
      return
    end

    @admin.destroy
    redirect_to admin_admins_path, notice: "管理员已删除"
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end
end
