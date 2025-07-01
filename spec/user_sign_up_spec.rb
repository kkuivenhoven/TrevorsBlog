require 'rails_helper'

RSpec.describe "User sign-up", type: :request do
  let(:valid_user_params) do
    {
      user: {
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end

  it "allows sign-up when honeypot is blank" do
    expect {
      post user_registration_path, params: valid_user_params.merge(nickname: "")
    }.to change(User, :count).by(1)
  end

  it "blocks sign-up when honeypot is filled" do
    expect {
      post user_registration_path, params: valid_user_params.merge(nickname: "bot")
    }.not_to change(User, :count)
  end
end
