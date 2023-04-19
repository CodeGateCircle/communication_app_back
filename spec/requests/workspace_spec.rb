require 'rails_helper'

RSpec.describe "Workspaces", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe "POST /workspaces" do
    let(:url) { "/workspaces" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        description: Faker::Name.name,
        iconImageUrl: Faker::Internet.url,
        coverImageUrl: Faker::Internet.url
      }
    end

    context "success" do
      # it '有効なworkspaceの場合は保存される' d o
      #   expect(FactoryBot.create(:workspace)).to be_valid
      # end

      it 'can create workspace' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['data']['workspace']['name']).to eq(body[:name])
        expect(res['data']['workspace']['description']).to eq(body[:description])
        expect(res['data']['workspace']['iconImageUrl']).to eq(body[:iconImageUrl])
        expect(res['data']['workspace']['coverImageUrl']).to eq(body[:coverImageUrl])
      end
    end

    context "error" do
      it 'can not create workspace without auth' do
        post url, params: body
        expect(response).to have_http_status 401
      end
    end
  end

  describe "PUT /workspaces/:workspace_id" do
    let(:url) {"/workspaces/:workspace_id"}
    let(:tokens) { get_auth_token(@user) }
    let(:body_after) do {
      name: Faker::Name.name,
      description: Faker::Name.name,
      iconImageUrl: Faker::Internet.url,
      coverImageUrl: Faker::Internet.url
    }
    end
    
    context "success" do
      before do
        @workspace = FactoryBot.create(:workspace)
      end

      it "can update data" do
        put url, params: body_after, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['data']['workspace']['name']).to eq(body_after[:name])
        expect(res['data']['workspace']['description']).to eq(body_after[:description])
        expect(res['data']['workspace']['iconImageUrl']).to eq(body_after[:iconImageUrl])
        expect(res['data']['workspace']['coverImageUrl']).to eq(body_after[:coverImageUrl])
      end
    end

    context "error" do
      it "can not update data without auth" do
        put url, params: body_after
        expect(response).to have_http_status 401
      end
    end
      
  end
end
