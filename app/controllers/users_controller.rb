class UsersController < ApplicationController
  skip_before_action :authorized, only: [ :create ]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content

  def index
    users = User.all

    render_jsonapi_response(users)
  end

  def show
    user = User.find(params[:id])

    render_jsonapi_response(user)
  end

  def create
    user = User.new(user_params)
    user.save!
    token = encode_token(user_id: user.id)

    render_jsonapi_response(user, status: :created, meta: { token: token })
  end

  def update
    user = User.find(params[:id])
    user.update!(user_params)

    render_jsonapi_response(user)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!

    head :no_content
  end

  private

  def render_not_found(exception)
    render_jsonapi_error(exception.message, status: :not_found)
  end

  def render_unprocessable_content(exception)
    render_jsonapi_error(exception.record.errors.full_messages, status: :unprocessable_content)
  end

  def user_params
    params.expect(user: [ :name, :email, :password, :password_confirmation ])
  end
end
