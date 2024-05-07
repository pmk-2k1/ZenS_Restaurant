# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  skip_before_action :authenticate_user!
  def create
    @user = User.find_by(email: params[:email])
    PasswordMailer.with(user: @user).reset.deliver_now if @user.present?
    render json: {
      alert: 'If this user exists, we have sent you a password reset email.'
    }
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render json: {
      alert: 'Your token has expired. Please try again.'
    }
  end

  def update
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
    if @user.update(password_params)
      render json: {
        alert: 'Your password was reset successfully. Please sign in.'
      }
    else
      render json: {
        alert: 'Your password has not been successfully reset. Please recheck your input information'
      }
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
