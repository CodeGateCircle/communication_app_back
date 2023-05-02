require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    @workspace_user = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user.id)
    @category = FactoryBot.create(:category)
  end

  describe "POST /rooms" do
    let(:url) { "/rooms" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        description: Faker::Name.name,
        categoryId: @category.id,
        workspaceId: @workspace.id
      }
    end

    context "success" do
      it 'can create room' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['data']['room']['name']).to eq(body[:name])
        expect(res['data']['room']['description']).to eq(body[:description])
        expect(res['data']['room']['categoryId']).to eq(body[:categoryId])
        expect(res['data']['room']['workspaceId']).to eq(body[:workspaceId])
        expect(RoomUser.find_by(user_id: @user.id).room_id).to eq(res['data']['room']['id'])
        expect(RoomUser.find_by(room_id: res['data']['room']['id']).user_id).to eq(@user.id)
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
