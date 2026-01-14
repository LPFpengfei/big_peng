# 认证控制器
# 处理用户登录、注册和登出功能
class Api::V1::AuthController < Api::V1::BaseController
  # 跳过CSRF保护
  skip_before_action :verify_authenticity_token
  # 不需要认证的动作
  skip_before_action :authenticate_user!, only: [ :login, :register ]

  # 用户登录
  # POST /api/v1/auth/login
  def login
    # 查找用户
    user = User.find_by(email: params[:email])

    # 验证用户和密码
    if user && user.authenticate(params[:password])
      # 生成JWT令牌
      token = JwtService.encode(user_id: user.id)
      # 返回成功响应
      render_success({ token: token, user: { id: user.id, email: user.email, nickname: user.nickname } })
    else
      # 返回错误响应
      render_error("邮箱或密码错误", status: :unauthorized)
    end
  end

  # 用户注册
  # POST /api/v1/auth/register
  def register
    # 创建用户
    user = User.new(user_params)

    if user.save
      # 生成JWT令牌
      token = JwtService.encode(user_id: user.id)
      # 返回成功响应
      render_success({ token: token, user: { id: user.id, email: user.email, nickname: user.nickname } })
    else
      # 返回错误响应
      render_error(user.errors.full_messages.join(", "))
    end
  end

  # 用户登出
  # DELETE /api/v1/auth/logout
  def logout
    # JWT是无状态的，登出操作主要在客户端进行（删除本地存储的令牌）
    # 这里可以添加令牌黑名单等高级功能，暂时只返回成功响应
    render_success({ message: "登出成功" })
  end

  private

  # 用户参数白名单
  def user_params
    params.permit(:email, :nickname, :password)
  end
end
