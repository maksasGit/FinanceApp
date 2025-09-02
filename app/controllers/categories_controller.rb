class CategoriesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content

    def index
        user_categories = current_user.categories
        default_categories = Category.where(user_id: nil)
        all_categories = default_categories + user_categories

        render json: all_categories, status: :ok
    end

    def show
        category = current_user.categories.find(params[:id])

        render json: category, status: :ok
    end

    def create
        category = current_user.categories.new(category_params)
        category.save!

        render json: category, status: :created
    end

    def update
        category = current_user.categories.find(params[:id])
        category.update!(category_params)

        render json: category, status: :ok
    end

    def destroy
        category = current_user.categories.find(params[:id])
        category.destroy!

        head :no_content
    end

    private

    def render_not_found(exception)
        render json: { error: exception.message }, status: :not_found
    end

    def render_unprocessable_content(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_content
    end

    def category_params
        params.expect(category: [ :parent_id, :name, :category_type ])
    end
end
