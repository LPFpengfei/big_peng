# 书架控制器
# 处理用户书架相关的API请求
class Api::V1::BookshelvesController < Api::V1::BaseController
  # 需要认证
  before_action :authenticate_user!

  # 获取用户书架列表
  # GET /api/v1/bookshelves
  def index
    # 获取当前用户的书架
    bookshelves = current_user.bookshelves.includes(:book)

    # 构建响应数据
    bookshelves_data = bookshelves.map do |bookshelf|
      book = bookshelf.book
      {
        id: bookshelf.id,
        book_id: book.id,
        title: book.title,
        author: book.author,
        description: book.description,
        cover_image: book.cover_image,
        added_at: bookshelf.created_at
      }
    end

    # 返回响应
    render_success(bookshelves: bookshelves_data)
  end

  # 添加书籍到书架
  # POST /api/v1/bookshelves
  def create
    # 查找书籍
    book = Book.find_by(id: params[:book_id])

    if book
      # 创建书架记录
      bookshelf = current_user.bookshelves.new(book_id: book.id)

      if bookshelf.save
        # 构建响应数据
        bookshelf_data = {
          id: bookshelf.id,
          book_id: book.id,
          title: book.title,
          author: book.author,
          description: book.description,
          cover_image: book.cover_image,
          added_at: bookshelf.created_at
        }

        # 返回成功响应
        render_success(bookshelf: bookshelf_data, status: :created)
      else
        # 返回错误响应
        render_error(bookshelf.errors.full_messages.join(", "))
      end
    else
      # 返回错误响应
      render_error("书籍不存在", status: :not_found)
    end
  end

  # 从书架移除书籍
  # DELETE /api/v1/bookshelves/:id
  def destroy
    # 查找书架记录
    bookshelf = current_user.bookshelves.find_by(id: params[:id])

    if bookshelf
      # 删除书架记录
      if bookshelf.destroy
        # 返回成功响应
        render_success({ message: "书籍已从书架移除" })
      else
        # 返回错误响应
        render_error("移除失败")
      end
    else
      # 返回错误响应
      render_error("书架记录不存在", status: :not_found)
    end
  end
end