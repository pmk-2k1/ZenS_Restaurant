require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Sign In User', type: :request do
  path '/users/sign_in' do
    post 'Sign In' do
      tag 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string},
          password: {type: :string},
        },
        required: ['email', 'password']
      }
      response '201', 'sign_in', {'HTTP_ACCEPT' => "application/json" } do
        response '201', 'sign_in', {'HTTP_ACCEPT' => "application/json" } do
          let(:user){{}}
        end
      end
    end
  end
end
