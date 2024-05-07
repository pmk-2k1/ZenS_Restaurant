# frozen_string_literal: true

class Users::RefreshTokensController < ApplicationController
  include Devise::Controllers::Helpers

  skip_before_action :authenticate_user!

  def create
    user = decode_refresh_token(refresh_token_params[:refresh_token])
    generate_refresh_token(user)
    sign_in(:user, User.first)
  end

  private

  def generate_refresh_token(user)
    token = user.generate_refresh_token
    response.headers['X-Refresh-Token'] = token
  end

  def decode_refresh_token(token)
    User.decode_refresh_token(token)
  end

  def refresh_token_params
    params.require(:user).permit(:jti)
  end
end
