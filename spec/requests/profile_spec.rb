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
      expect(res['data']['id']).to eq(@user.id)
      expect(res['data']['email']).to eq(@user.email)
      expect(res['data']['uid']).to eq(@user.uid)
      expect(res['data']['name']).to eq(@user.name)
      expect(res['data']['image']).to eq(@user.image)
      expect(res['data']['provider']).to eq(@user.provider)
    end

    it 'can not get profile without auth' do
      get "/profile"
      expect(response).to have_http_status 401
    end
  end
end
