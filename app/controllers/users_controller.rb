# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
    render json: {
      user: current_user.as_json(except: :jti)
    }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:fullname, :email, :password, :username, :address, :date_of_birth,
                                 :role, :gender, :reset_password_token, :avatar,
                                 :current_password, :password_confirmation)
  end
end
