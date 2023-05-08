require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe "GET /index" do
    it 'can get profile' do
      tokens = get_auth_token(@user)
      get "/profile", headers: tokens
      expect(response).to have_http_status :ok
      res = JSON.parse(response.body)
      expect(res['user']['id']).to eq(@user.id)
      expect(res['user']['email']).to eq(@user.email)
      expect(res['user']['name']).to eq(@user.name)
      expect(res['user']['image']).to eq(@user.image)
    end

    it 'can not get profile without auth' do
      get "/profile"
      expect(response).to have_http_status 401
    end
  end
end
