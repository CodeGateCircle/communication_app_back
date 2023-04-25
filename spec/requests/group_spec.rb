require 'rails_helper'

RSpec.describe "Groups", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    @workspace_user = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user.id)
  end

  describe "POST /groups" do
    let(:url) { "/groups" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        description: Faker::Name.name,
        iconImageUrl: Faker::Internet.url,
        workspaceId: @workspace.id
      }
    end

    context "success" do
      it 'can create group' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['data']['group']['name']).to eq(body[:name])
        expect(res['data']['group']['description']).to eq(body[:description])
        expect(res['data']['group']['iconImageUrl']).to eq(body[:iconImageUrl])
        expect(res['data']['group']['workspaceId']).to eq(body[:workspaceId])

        expect(GroupUser.find_by(user_id: @user.id).group_id).to eq(res['data']['group']['id'])
        expect(GroupUser.find_by(user_id: @user.id).workspace_id).to eq(res['data']['group']['workspaceId'])
        expect(GroupUser.find_by(workspace_id: res['data']['group']['workspaceId'], group_id: res['data']['group']['id']).user_id).to eq(@user.id)
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
