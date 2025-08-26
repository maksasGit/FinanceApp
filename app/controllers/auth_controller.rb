class AuthController < ApplicationController
    skip_before_action :authorized, only: [ :login ]

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    def login
        @user = User.find_by!(email: login_params[:email])
        if @user.authenticate(login_params[:password])
            @token = encode_token(user_id: @user.id)
            render json: {
                user: @user,
                token: @token
            }, status: :accepted
        else
            render json: { message: "Incorrect password" }, status: :unauthorized
        end
    end

    private

    def login_params
        params.expect(auth: [ :email, :password ])
    end

    def render_not_found(exceptione)
        render json: { message: "User doesn't exist" }, status: :unauthorized
    end
end
