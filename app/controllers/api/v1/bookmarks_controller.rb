# 书签控制器
# 处理用户书签相关的API请求
class Api::V1::BookmarksController < Api::V1::BaseController
  # 需要认证
  before_action :authenticate_user!

  # 获取用户书签列表
  # GET /api/v1/bookmarks
  def index
    # 构建查询
    bookmarks = current_user.bookmarks.includes(:book)

    # 支持按书籍筛选
    if params[:book_id].present?
      bookmarks = bookmarks.where(book_id: params[:book_id])
    end

    # 按创建时间倒序排序
    bookmarks = bookmarks.order(created_at: :desc)

    # 构建响应数据
    bookmarks_data = bookmarks.map do |bookmark|
      book = bookmark.book
      {
        id: bookmark.id,
        book_id: book.id,
        book_title: book.title,
        chapter: bookmark.chapter,
        page: bookmark.page,
        note: bookmark.note,
        created_at: bookmark.created_at,
        updated_at: bookmark.updated_at
      }
    end

    # 返回响应
    render_success(bookmarks: bookmarks_data)
  end

  # 创建书签
  # POST /api/v1/bookmarks
  def create
    # 查找书籍
    book = Book.find_by(id: params[:book_id])

    if book
      # 创建书签
      bookmark = current_user.bookmarks.new(bookmark_params)

      if bookmark.save
        # 构建响应数据
        bookmark_data = {
          id: bookmark.id,
          book_id: book.id,
          book_title: book.title,
          chapter: bookmark.chapter,
          page: bookmark.page,
          note: bookmark.note,
          created_at: bookmark.created_at,
          updated_at: bookmark.updated_at
        }

        # 返回成功响应
        render_success(bookmark: bookmark_data, status: :created)
      else
        # 返回错误响应
        render_error(bookmark.errors.full_messages.join(", "))
      end
    else
      # 返回错误响应
      render_error("书籍不存在", status: :not_found)
    end
  end

  # 更新书签
  # PUT /api/v1/bookmarks/:id
  def update
    # 查找书签
    bookmark = current_user.bookmarks.find_by(id: params[:id])

    if bookmark
      # 更新书签
      if bookmark.update(bookmark_params)
        # 构建响应数据
        bookmark_data = {
          id: bookmark.id,
          book_id: bookmark.book.id,
          book_title: bookmark.book.title,
          chapter: bookmark.chapter,
          page: bookmark.page,
          note: bookmark.note,
          created_at: bookmark.created_at,
          updated_at: bookmark.updated_at
        }

        # 返回成功响应
        render_success(bookmark: bookmark_data)
      else
        # 返回错误响应
        render_error(bookmark.errors.full_messages.join(", "))
      end
    else
      # 返回错误响应
      render_error("书签不存在", status: :not_found)
    end
  end

  # 删除书签
  # DELETE /api/v1/bookmarks/:id
  def destroy
    # 查找书签
    bookmark = current_user.bookmarks.find_by(id: params[:id])

    if bookmark
      # 删除书签
      if bookmark.destroy
        # 返回成功响应
        render_success({ message: "书签已删除" })
      else
        # 返回错误响应
        render_error("删除失败")
      end
    else
      # 返回错误响应
      render_error("书签不存在", status: :not_found)
    end
  end

  private

  # 书签参数白名单
  def bookmark_params
    params.permit(:book_id, :chapter, :page, :note)
  end
end
