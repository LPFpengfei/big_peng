# 分类控制器
# 处理分类相关的API请求
class Api::V1::CategoriesController < Api::V1::BaseController
  # 不需要认证
  skip_before_action :authenticate_user!

  # 获取分类列表
  # GET /api/v1/categories
  def index
    # 获取所有分类
    categories = Category.all.order(name: :asc)

    # 构建响应数据
    categories_data = categories.map do |category|
      {
        id: category.id,
        name: category.name,
        description: category.description,
        created_at: category.created_at,
        updated_at: category.updated_at
      }
    end

    # 返回响应
    render_success(categories: categories_data)
  end

  # 获取分类详情
  # GET /api/v1/categories/:id
  def show
    # 查找分类
    category = Category.find_by(id: params[:id])

    if category
      # 获取分类下的书籍
      books = category.books.page(params[:page] || 1).per(params[:per_page] || 10)

      # 构建书籍数据
      books_data = books.map do |book|
        {
          id: book.id,
          title: book.title,
          author: book.author,
          description: book.description,
          cover_image: book.cover_image,
          source: book.source,
          created_at: book.created_at,
          updated_at: book.updated_at
        }
      end

      # 构建分类数据
      category_data = {
        id: category.id,
        name: category.name,
        description: category.description,
        books: books_data,
        pagination: {
          current_page: books.current_page,
          total_pages: books.total_pages,
          total_count: books.total_count,
          per_page: books.limit_value
        },
        created_at: category.created_at,
        updated_at: category.updated_at
      }

      # 返回成功响应
      render_success(category: category_data)
    else
      # 返回错误响应
      render_error("分类不存在", status: :not_found)
    end
  end
end