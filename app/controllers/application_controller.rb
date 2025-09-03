class ApplicationController < ActionController::API
  before_action :authorized

  SECRET_KEY = Rails.application.secret_key_base

  def encode_token(payload)
    exp = 1.day.from_now.to_i
    payload = payload.merge({ exp: exp })

    JWT.encode(payload, SECRET_KEY)
  end

  def decoded_token
    header = request.headers["Authorization"]
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
      rescue JWT::ExpiredSignature
        nil
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    return @current_user if defined?(@current_user)

    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @current_user = User.find_by(id: user_id)
    end
  end

  def authorized
    unless !!current_user
      render json: { message: "Please log in" }, status: :unauthorized
    end
  end
end
