require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'Make sure you have your email and password to log in' do
      user = User.new(email: '', password: '').save
      expect(joke).to eq(false)
    end
  end
end
