class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # 启用 CSRF 保护
  protect_from_forgery with: :exception

  before_action :require_admin_login

  private

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  def require_admin_login
    unless current_admin
      if request.xhr? || request.format.json?
        render json: { success: false, errors: [ "请先登录" ] }, status: :unauthorized
      else
        redirect_to admin_login_path, alert: "请先登录"
      end
    end
  end
end
