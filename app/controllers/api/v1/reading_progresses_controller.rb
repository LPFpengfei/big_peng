# 阅读进度控制器
# 处理用户阅读进度相关的API请求
class Api::V1::ReadingProgressesController < Api::V1::BaseController
  # 需要认证
  before_action :authenticate_user!

  # 获取阅读进度
  # GET /api/v1/reading_progresses/:book_id
  def show
    # 查找阅读进度
    reading_progress = current_user.reading_progresses.find_by(book_id: params[:book_id])

    if reading_progress
      # 构建响应数据
      reading_progress_data = {
        id: reading_progress.id,
        book_id: reading_progress.book_id,
        chapter: reading_progress.chapter,
        page: reading_progress.page,
        updated_at: reading_progress.updated_at
      }

      # 返回成功响应
      render_success(reading_progress: reading_progress_data)
    else
      # 返回空的阅读进度
      render_success(reading_progress: nil)
    end
  end

  # 更新阅读进度
  # PUT /api/v1/reading_progresses/:book_id
  def update
    # 查找书籍
    book = Book.find_by(id: params[:book_id])

    if book
      # 查找或创建阅读进度
      reading_progress = current_user.reading_progresses.find_or_initialize_by(book_id: book.id)

      if reading_progress.update(reading_progress_params)
        # 构建响应数据
        reading_progress_data = {
          id: reading_progress.id,
          book_id: reading_progress.book_id,
          chapter: reading_progress.chapter,
          page: reading_progress.page,
          updated_at: reading_progress.updated_at
        }

        # 返回成功响应
        render_success(reading_progress: reading_progress_data)
      else
        # 返回错误响应
        render_error(reading_progress.errors.full_messages.join(", "))
      end
    else
      # 返回错误响应
      render_error("书籍不存在", status: :not_found)
    end
  end

  private

  # 阅读进度参数白名单
  def reading_progress_params
    params.permit(:chapter, :page)
  end
end