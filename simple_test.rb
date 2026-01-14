#!/usr/bin/env ruby

# 简单测试脚本，不依赖登录
require 'net/http'
require 'uri'
require 'json'

# 服务器地址
BASE_URL = 'http://localhost:3000'

# 测试用户创建
def test_user_creation
  uri = URI.parse(BASE_URL + '/admin/users.json')
  request = Net::HTTP::Post.new(uri)

  # 不设置身份验证，直接发送请求
  request['Content-Type'] = 'application/json'
  request['Accept'] = 'application/json'

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

  puts "状态码: #{response.code}"
  puts "响应体: #{response.body}"
  puts "响应头: #{response.to_hash}"

  if response.code == '201'
    puts "✅ 用户创建成功！"
  else
    puts "❌ 用户创建失败！"
  end
end

# 运行测试
puts "开始简单测试..."
test_user_creation
