# 管理端图书控制器
# 处理管理员对图书的管理操作
class Admin::BooksController < ApplicationController
  layout "admin"
  before_action :require_admin_login
  before_action :set_book, only: [ :show, :edit, :update, :destroy ]

  # 图书列表
  # GET /admin/books
  def index
    @books = Book.all.order(created_at: :desc).page(params[:page])
    @book = Book.new
  end

  # 图书详情
  # GET /admin/books/:id
  def show
  end

  # 新建图书页面
  # GET /admin/books/new
  def new
    @book = Book.new
    render :form, layout: false
  end

  # 创建图书
  # POST /admin/books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: { success: true, message: "图书创建成功" }
    else
      render json: { success: false, errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 编辑图书页面
  # GET /admin/books/:id/edit
  def edit
    render :form, layout: false
  end

  # 更新图书
  # PUT /admin/books/:id
  def update
    if @book.update(book_params)
      render json: { success: true, message: "图书更新成功" }
    else
      render json: { success: false, errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 删除图书
  # DELETE /admin/books/:id
  def destroy
    @book.destroy
    redirect_to admin_books_path, notice: "图书已删除"
  end

  private

  # 设置图书
  def set_book
    @book = Book.find(params[:id])
  end

  # 图书参数白名单
  def book_params
    params.require(:book).permit(:title, :author, :description, :cover_image, :file_path, :category_id, :source)
  end
end
