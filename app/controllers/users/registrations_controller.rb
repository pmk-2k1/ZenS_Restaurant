# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _options = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully',
                  data: {
                    email: current_user.email,
                    fullname: current_user.fullname,
                    username: current_user.username,
                    address: current_user.address,
                    roll: current_user.role,
                    day_of_birth: current_user.day_of_birth,
                    gender: current_user.gender,
                    avatar: current_user.avatar
                  } }
      }, status: :ok
    else
      render json: {
        status: { message: 'User could not be created successfully',
                  errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end
end
