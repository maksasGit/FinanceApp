class ApplicationController < ActionController::API
  before_action :authorized

  SECRET_KEY = Rails.application.secret_key_base

  def render_jsonapi_response(collection, status: :ok, serializer: nil, include: nil, meta: {})
    serializer ||= serializer_for(collection)
    return unless serializer

    options = build_serialization_options(collection, include, meta)
    response = serializer.new(collection, **options).serializable_hash

    render json: response, status: status
  end

  def render_jsonapi_error(resource, status: :unprocessable_content)
    errors = normalize_errors(resource)

    render json: errors_response(errors, status), status: status
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
    return if current_user

    render_jsonapi_error("Please log in", status: :unauthorized)
  end

  private

  def build_serialization_options(collection, include, meta)
    options = { meta: meta }
    options[:include] = include if include.present? && collection.present?

    options
  end

  def normalize_errors(resource)
    return resource if resource.is_a?(Array)
    return [ resource ] if resource.is_a?(String)

    [ "Unexpected error occurred" ]
  end

  def errors_response(errors, status)
    code = status_code(status)
    title = status_title(code)

    {
      errors: errors.map do |error_message|
        {
          status: code,
          title: title,
          detail: error_message
        }
      end
    }
  end

  def serializer_for(collection)
    collection_class = if collection.respond_to?(:to_ary)
      collection.to_ary.first&.class
    else
      collection.class
    end

    collection_class = "Default" if collection_class.nil?

    serializer_name = "#{collection_class}Serializer"
    serializer = serializer_name.safe_constantize

    unless serializer
      Rails.logger.error("Serializer not found for #{collection_class}")
      render_jsonapi_error(nil, status: :internal_server_error)
    end

    serializer
  end

  def status_code(status)
    Rack::Utils.status_code(status).to_s
  end

  def status_title(code)
    Rack::Utils::HTTP_STATUS_CODES[code.to_i] || "Error"
  end
end
