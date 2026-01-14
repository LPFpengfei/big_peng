# 书籍控制器
# 处理书籍相关的API请求
class Api::V1::BooksController < Api::V1::BaseController
  # 不需要认证的动作
  skip_before_action :authenticate_user!, only: [:index, :show]

  # 获取书籍列表
  # GET /api/v1/books
  def index
    # 构建查询
    books = Book.all

    # 支持按分类筛选
    if params[:category_id].present?
      books = books.where(category_id: params[:category_id])
    end

    # 支持搜索
    if params[:q].present?
      query = "%#{params[:q]}%"
      books = books.where("title ILIKE ? OR author ILIKE ?", query, query)
    end

    # 分页
    books = books.page(params[:page] || 1).per(params[:per_page] || 10)

    # 构建响应数据
    books_data = books.map do |book|
      {
        id: book.id,
        title: book.title,
        author: book.author,
        description: book.description,
        cover_image: book.cover_image,
        category_id: book.category_id,
        source: book.source,
        created_at: book.created_at,
        updated_at: book.updated_at
      }
    end

    # 返回响应
    render_success(
      books: books_data,
      pagination: {
        current_page: books.current_page,
        total_pages: books.total_pages,
        total_count: books.total_count,
        per_page: books.limit_value
      }
    )
  end

  # 获取书籍详情
  # GET /api/v1/books/:id
  def show
    # 查找书籍
    book = Book.find_by(id: params[:id])

    if book
      # 构建响应数据
      book_data = {
        id: book.id,
        title: book.title,
        author: book.author,
        description: book.description,
        cover_image: book.cover_image,
        file_path: book.file_path,
        category_id: book.category_id,
        source: book.source,
        created_at: book.created_at,
        updated_at: book.updated_at
      }

      # 返回成功响应
      render_success(book: book_data)
    else
      # 返回错误响应
      render_error("书籍不存在", status: :not_found)
    end
  end

  # 创建书籍
  # POST /api/v1/books
  def create
    # 只允许管理员创建书籍，这里简化处理，实际项目中应该添加管理员权限验证

    # 创建书籍
    book = Book.new(book_params)

    if book.save
      # 返回成功响应
      render_success(book: book, status: :created)
    else
      # 返回错误响应
      render_error(book.errors.full_messages.join(", "))
    end
  end

  # 更新书籍
  # PUT /api/v1/books/:id
  def update
    # 只允许管理员更新书籍，这里简化处理，实际项目中应该添加管理员权限验证

    # 查找书籍
    book = Book.find_by(id: params[:id])

    if book
      # 更新书籍
      if book.update(book_params)
        # 返回成功响应
        render_success(book: book)
      else
        # 返回错误响应
        render_error(book.errors.full_messages.join(", "))
      end
    else
      # 返回错误响应
      render_error("书籍不存在", status: :not_found)
    end
  end

  # 删除书籍
  # DELETE /api/v1/books/:id
  def destroy
    # 只允许管理员删除书籍，这里简化处理，实际项目中应该添加管理员权限验证

    # 查找书籍
    book = Book.find_by(id: params[:id])

    if book
      # 删除书籍
      if book.destroy
        # 返回成功响应
        render_success({ message: "书籍删除成功" })
      else
        # 返回错误响应
        render_error("书籍删除失败")
      end
    else
      # 返回错误响应
      render_error("书籍不存在", status: :not_found)
    end
  end

  private

  # 书籍参数白名单
  def book_params
    params.permit(:title, :author, :description, :cover_image, :file_path, :category_id, :source)
  end
end