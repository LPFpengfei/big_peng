class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    return nil unless token

    begin
      decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
      decoded.first
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::InvalidToken
      nil
    end
  end
end
