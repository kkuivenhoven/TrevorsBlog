require 'rails_helper'

RSpec.describe "PromptForTrainings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/prompt_for_trainings/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/prompt_for_trainings/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/prompt_for_trainings/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/prompt_for_trainings/show"
      expect(response).to have_http_status(:success)
    end
  end

end
