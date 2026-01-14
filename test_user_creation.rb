#!/usr/bin/env ruby

# 测试用户创建API
require 'net/http'
require 'uri'
require 'json'

# 服务器地址
BASE_URL = 'http://localhost:3000'

# 创建用户
def create_user
  uri = URI.parse(BASE_URL + '/admin/users.json')
  request = Net::HTTP::Post.new(uri)

  # 设置请求头
  request['Content-Type'] = 'application/json'
  request['Accept'] = 'application/json'
  request['X-Requested-With'] = 'XMLHttpRequest'

  # 生成随机用户名
  random_email = "test_#{Time.now.to_i}@example.com"

  # 请求体
  user_data = {
    user: {
      email: random_email,
      password: 'password123',
      password_confirmation: 'password123',
      name: 'Test User',
      role: 'user'
    }
  }

  request.body = user_data.to_json

  # 发送请求
  response = Net::HTTP.start(uri.host, uri.port) do |http|
    http.request(request)
  end

  puts "Request URL: #{uri}"
  puts "Request Body: #{user_data}"
  puts "Response Code: #{response.code}"
  puts "Response Body: #{response.body}"
  puts "Response Headers: #{response.to_hash}"

  response
end

# 测试文件上传
def test_file_upload
  uri = URI.parse(BASE_URL + '/admin/users.json')
  request = Net::HTTP::Post.new(uri)

  # 设置请求头
  request['Accept'] = 'application/json'
  request['X-Requested-With'] = 'XMLHttpRequest'

  # 生成随机用户名
  random_email = "test_#{Time.now.to_i}@example.com"

  # 构建multipart/form-data请求
  boundary = "----WebKitFormBoundary#{rand(100000000000000000000)}"
  request['Content-Type'] = "multipart/form-data; boundary=#{boundary}"

  # 构建请求体
  body = []
  body << "--#{boundary}"
  body << "Content-Disposition: form-data; name=\"user[email]\""
  body << ""
  body << random_email
  body << "--#{boundary}"
  body << "Content-Disposition: form-data; name=\"user[password]\""
  body << ""
  body << 'password123'
  body << "--#{boundary}"
  body << "Content-Disposition: form-data; name=\"user[password_confirmation]\""
  body << ""
  body << 'password123'
  body << "--#{boundary}"
  body << "Content-Disposition: form-data; name=\"user[name]\""
  body << ""
  body << 'Test User'
  body << "--#{boundary}"
  body << "Content-Disposition: form-data; name=\"user[role]\""
  body << ""
  body << 'user'
  body << "--#{boundary}--"
  body << ""

  request.body = body.join("\r\n")

  # 发送请求
  response = Net::HTTP.start(uri.host, uri.port) do |http|
    http.request(request)
  end

  puts "\n=== File Upload Test ==="
  puts "Request URL: #{uri}"
  puts "Response Code: #{response.code}"
  puts "Response Body: #{response.body}"

  response
end

# 运行测试
puts "=== 测试用户创建API ==="
create_user

# 运行文件上传测试
test_file_upload
