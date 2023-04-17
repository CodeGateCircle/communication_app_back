require 'rails_helper'

RSpec.describe "Workspaces", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe "POST /workspaces" do
    let(:url) {"/workspaces"}
    let(:tokens) {get_auth_token(@user)}
    let(:body) do
      {
        "workspace": {
          "name": Faker::Name.name,
          "description": Faker::Name.name,
          "iconImageUrl": Faker::Internet.url,
          "coverImageUrl": Faker::Internet.url
        }
      }
    end
    
    context "success" do
      it '有効なworkspaceの場合は保存される' do
        expect(FactoryBot.create(:workspace)).to be_valid
      end

      it 'can create workspace' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['data']['workspace']['workspaceId']).not_to eq nil
        expect(res['data']['workspace']['name']).to eq(body[:workspace][:name])
        expect(res['data']['workspace']['description']).to eq(body[:workspace][:description])
        expect(res['data']['workspace']['iconImageUrl']).to eq(body[:workspace][:iconImageUrl])
        expect(res['data']['workspace']['coverImageUrl']).to eq(body[:workspace][:coverImageUrl])
      end
    end

    context "error" do
      it 'can not create workspace without auth' do
        post url, params: body
        expect(response).to have_http_status 401
      end
    end

  end


end