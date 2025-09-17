class CategoriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content
  # rescue_from ActiveRecord::InvalidForeignKey, with: :render_invalid_foreign_key
  rescue_from ArgumentError, with: :render_invalid_enum

  def index
    categories = Category.where("user_id = ? OR user_id IS NULL", current_user.id)

    render_jsonapi_response(categories)
  end

  def show
    category = current_user.categories.where(id: params[:id])
              .or(Category.where(id: params[:id], user_id: nil))
              .first!

    render_jsonapi_response(category)
  end

  def create
    category = current_user.categories.new(category_params)
    category.save!

    render_jsonapi_response(category, status: :created)
  end

  def update
    category = current_user.categories.find(params[:id])
    category.update!(category_params)

    render_jsonapi_response(category)
  end

  def destroy
    category = current_user.categories.find(params[:id])
    category.destroy!

    head :no_content
  end

  private

  def render_invalid_enum(exception)
    render_jsonapi_error(exception.message, status: :unprocessable_content)
  end

  def render_invalid_foreign_key(exception)
    render_jsonapi_error("Not existing parent category", status: :unprocessable_content)
  end

  def render_not_found(exception)
    render_jsonapi_error(exception.message, status: :not_found)
  end

  def render_unprocessable_content(exception)
    render_jsonapi_error(exception.record.errors.full_messages, status: :unprocessable_content)
  end

  def category_params
    params.expect(category: [ :parent_id, :name, :category_type ])
  end
end
