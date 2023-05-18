require 'rails_helper'

RSpec.describe "Categories", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    @workspace_user = FactoryBot.create(
      :workspace_user,
      workspace: @workspace,
      user: @user
    )
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

        p response
        res = JSON.parse(response.body)
        p res
        expect(res['data']['category']['name']).to eq(body[:name])
        expect(res['data']['category']['workspaceId']).to eq(body[:workspaceId])
      end
    end

    context "error" do
      it "cannot edit workspace without auth" do
        @user_other = FactoryBot.create(:user)
        post url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 401
      end
    end
  end

  describe "GET /categories" do
    let(:url) { "/categories" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        workspace_id: @workspace.id
      }
    end

    context "success" do
      it "can get categories" do
        all_index = 10
        category = FactoryBot.create_list(:category, all_index, workspace: @workspace)
        get url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['data']['categories'].size).to eq(all_index)
        expect(res['data']['categories'][0]['workspaceId'] == category[0][:workspace_id]).to be true
        expect(res['data']['categories'][0]['name'] == category[0][:name]).to be true

        category.each_with_index do |cat, n|
          expect(res['data']['categories'][n]['workspaceId'] == cat[:workspace_id]).to be true
          expect(res['data']['categories'][n]['name'] == cat[:name]).to be true
        end
      end
    end

    context "error" do
      it "cannot get categories without auth" do
        @user_other = FactoryBot.create(:user)
        get url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 401
      end
    end
  end

  describe "PUT /categories/:category_id" do
    let(:url) { "/categories/#{category.id}" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        workspaceId: @workspace.id
      }
    end
    let(:category) { FactoryBot.create(:category, workspace: @workspace) }

    context "success" do
      it 'can update category' do
        put url, params: body, headers: tokens
        expect(response).to have_http_status :ok

        res = JSON.parse(response.body)
        expect(res['data']['category']['name']).to eq(body[:name])
        expect(res['data']['category']['workspace_id']).to eq(body[:workspace_id])
      end
    end

    context "error" do
      it 'can not update category without auth' do
        @user_other = FactoryBot.create(:user)
        put url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 401
      end
    end
  end

  describe "POST /categories/:category_id/delete" do
    let(:url) { "/categories/#{category.id}/delete" }
    let(:tokens) { get_auth_token(@user) }
    let(:category) { FactoryBot.create(:category, workspace: @workspace) }

    context "success" do
      it 'can delete category' do
        post url, headers: tokens
        expect(response).to have_http_status :ok
        expect(Room.find_by(category_id: category.id)).to be_blank
        expect(Category.find_by(id: category.id)).to be_blank
      end
    end
    # cannot delete
    # - no auth
    # + auth have
    # + some rooms in this category exist
    context "error" do
      it 'cannot delete it because some rooms in this category exist' do
        @room = FactoryBot.create(:room, category:, workspace: @workspace)
        post url, headers: tokens
        expect(response).to have_http_status 401
      end

      it 'cannot delete it because no auth' do
        @user_other = FactoryBot.create(:user)
        post url, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 401
      end
    end
  end
end
