require 'rails_helper'

RSpec.describe "Categories", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    @workspace_user = FactoryBot.create(
      :workspace_user,
      workspace_id: @workspace.id,
      user_id: @user.id
    )
    @user_other = FactoryBot.create(:user)
  end
  describe "POST /categories" do
    let(:url) { "/categories" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        workspaceId: @workspace.id
      }
    end

    context "success" do
      it "can create category" do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok

        workspace_user = WorkspaceUser.find_by(workspace_id: body[:workspaceId])
        expect(workspace_user).not_to be_nil
        expect(workspace_user.user_id).to eq(@user.id)

        res = JSON.parse(response.body)
        expect(res['data']['category']['name']).to eq(body[:name])
        expect(res['data']['category']['workspaceId']).to eq(body[:workspaceId])
      end
    end

    context "error" do
      it "cannot edit workspace without auth" do
        post url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 400
      end
    end


  end
end
