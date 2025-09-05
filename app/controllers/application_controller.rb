class ApplicationController < ActionController::API
  before_action :authorized

  SECRET_KEY = Rails.application.secret_key_base

  def render_jsonapi_response(collection, status: :ok, serializer: nil, include: nil, meta: {})
    serializer ||= serializer_for(collection)

    options = { meta: meta }
    options[:include] = include if include.present?

    response = serializer.new(collection, **options).serializable_hash

    render json: response, status: status
  end

  def render_jsonapi_error(resource, status: :unprocessable_content)
    errors = case resource
    when Array
      resource
    when String
      [ resource ]
    else
      [ "Unexpected error occurred" ]
    end

    status_code = Rack::Utils.status_code(status).to_s
    title = Rack::Utils::HTTP_STATUS_CODES[status_code.to_i] || "Error"

    render json: {
      errors: errors.map do |error_message|
        {
          status: status_code,
          title: title,
          detail: error_message
        }
      end
    }, status: status
  end

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
      render_jsonapi_error("Please log in", status: :unauthorized)
    end
  end

  private

  def serializer_for(collection)
    collection_class = if collection.respond_to?(:to_ary)
      collection.to_ary.first&.class
    else
      collection.class
    end

    raise "Cannot infer serializer from empty collection" if collection_class.nil?

    serializer_name = "#{collection_class}Serializer"
    serializer_name.safe_constantize || raise("Serializer not found for #{collection_class}")
  end
end
