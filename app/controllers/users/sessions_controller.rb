# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  SECRET_KEY = Rails.application.secret_key_base
  def jwt_encode(payload, exp = 30.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  private

  def respond_with(_resource, _options = {})
    access_token = jwt_encode(user_id: current_user.id)
    render json: {
      status: { code: 200, message: 'User signed in successfully',
                data: {
                  email: current_user.email,
                  fullname: current_user.fullname,
                  username: current_user.username,
                  address: current_user.address,
                  roll: current_user.role,
                  day_of_birth: current_user.day_of_birth,
                  gender: current_user.gender,
                  avatar: current_user.avatar,
                  access_token: access_token
                } }
    }, status: :ok
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                             Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
      render json: {
        status: 200,
        message: 'Signed out successfully'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: 'Use had no active session'
      }, status: :unauthorized
    end
  end
end
