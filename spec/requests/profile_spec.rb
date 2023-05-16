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

  describe "PUT /profile" do
    let(:token) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        image: Faker::Internet.url
      }
    end
    it 'can update profile' do
      put '/profile', params: body, headers: token
      expect(response).to have_http_status :ok
      res = JSON.parse(response.body)
      expect(res['data']['name']).to eq(body[:name])
      expect(res['data']['image']).to eq(body[:image])
    end

    it 'cannot edit profile without auth' do
      put '/profile', params: body
      expect(response).to have_http_status 401
    end
  end

  # delete profile
  describe "POST /profile/delete" do
    let(:tokens) { get_auth_token(@user) }

    context "success" do
      it 'can delete profile' do
        post '/profile/delete', headers: tokens
        expect(response).to have_http_status :ok
        expect(User.find(@user.id).is_deleted).to be true
      end
    end
    context "error" do
      it 'cannot delete profile' do
        post '/profile/delete'
        expect(response).to have_http_status 401
      end
    end
  end
end
