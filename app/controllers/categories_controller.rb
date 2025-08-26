class CategoriesController < ApplicationController
    def index
        categories = Category.all
        render json: categories, status: :ok
    end

    def show
        category = Category.find(params[:id])
        render json: category, status: :ok
    end

    def create
        category = Category.new(category_params)
        if category.save
            render json: category, status: :created
        else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_content
        end
    end

    private

    def category_params
        params.expect(category: [ :user_id, :parent_id, :name, :category_type ])
    end
end
