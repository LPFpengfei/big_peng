#!/usr/bin/env ruby

# 测试用户创建API
require 'net/http'
require 'uri'
require 'json'

# 服务器地址
BASE_URL = 'http://localhost:3000'
ADMIN_USERNAME = 'admin@example.com'
ADMIN_PASSWORD = 'password123'

# 获取CSRF令牌和Cookie
def get_csrf_token
  uri = URI.parse(BASE_URL + '/admin/login')
  request = Net::HTTP::Get.new(uri)
  response = Net::HTTP.start(uri.host, uri.port) do |http|
    http.request(request)
  end

  # 从响应头获取Cookie
  cookie = response['set-cookie']

  # 从响应体获取CSRF令牌
  csrf_token = response.body.match(/csrf-token" content="([^"]+)"/)&.captures&.first

  { cookie: cookie, csrf_token: csrf_token }
end

# 管理员登录
def admin_login(cookie, csrf_token)
  uri = URI.parse(BASE_URL + '/admin/login')
  request = Net::HTTP::Post.new(uri)
  request['Cookie'] = cookie
  request['X-CSRF-Token'] = csrf_token
  request['Content-Type'] = 'application/x-www-form-urlencoded'

  request.body = URI.encode_www_form({
    'admin[email]' => ADMIN_USERNAME,
    'admin[password]' => ADMIN_PASSWORD,
    'commit' => 'Login'
  })

  response = Net::HTTP.start(uri.host, uri.port) do |http|
    http.request(request)
  end

  response['set-cookie']
end

# 创建用户
def create_user(cookie, csrf_token)
  uri = URI.parse(BASE_URL + '/admin/users.json')
  request = Net::HTTP::Post.new(uri)
  request['Cookie'] = cookie
  request['X-CSRF-Token'] = csrf_token
  request['X-Requested-With'] = 'XMLHttpRequest'
  request['Accept'] = 'application/json'
  request['Content-Type'] = 'application/json'

  user_data = {
    user: {
      email: "test#{rand(10000)}@example.com",
      password: 'password123',
      password_confirmation: 'password123',
      name: 'Test User',
      role: 'user'
    }
  }

  request.body = user_data.to_json

  response = Net::HTTP.start(uri.host, uri.port) do |http|
    http.request(request)
  end

  {
    status: response.code,
    body: response.body
  }
end

# 主测试流程
def run_test
  puts "开始测试用户创建API..."

  # 获取CSRF令牌和Cookie
  puts "1. 获取CSRF令牌和Cookie..."
  auth_data = get_csrf_token
  puts "   CSRF Token: #{auth_data[:csrf_token]}"
  puts "   Cookie: #{auth_data[:cookie]}"

  # 管理员登录
  puts "2. 管理员登录..."
  session_cookie = admin_login(auth_data[:cookie], auth_data[:csrf_token])
  puts "   Session Cookie: #{session_cookie}"

  # 创建用户
  puts "3. 创建用户..."
  result = create_user(session_cookie, auth_data[:csrf_token])
  puts "   响应状态: #{result[:status]}"
  puts "   响应体: #{result[:body]}"

  if result[:status] == '201'
    puts "✅ 用户创建成功！"
  else
    puts "❌ 用户创建失败！"
  end
end

# 运行测试
run_test
