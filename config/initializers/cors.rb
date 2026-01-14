# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # 在生产环境中，应该限制为特定的域名，例如：'https://your-harmonyos-app.com'

    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: %i[Authorization]
  end
end
