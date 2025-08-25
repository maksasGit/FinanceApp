class UsersController < ApplicationController
    def index
        users = User.all
        render json: users, status: :ok
    end

    def show
        user = User.find(params[:id])
        render json: user, status: :ok
    end

    def create
        user = User.new(user_params)
        if user.save
            render json: user, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_content
        end
    end

    private

    def user_params
        params.expect(user: [ :name, :email, :password ])
    end
end
