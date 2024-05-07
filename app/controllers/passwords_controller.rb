# frozen_string_literal: true

class PasswordsController < ApplicationController
  def update
    if current_user.update(password_params)
      render json: {
        status: { code: 200, message: 'Password update!' }
      }, status: :ok
    else
      render json: {
        status: { message: 'Invalid password!',
                  errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
