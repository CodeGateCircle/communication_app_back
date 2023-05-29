require 'rails_helper'

RSpec.describe "Workspaces", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe "GET /workspaces" do
    let(:url) { "/workspaces" }
    let(:tokens) { get_auth_token(@user) }

    before(:each) do
      @workspace1 = FactoryBot.create(:workspace)
      @workspace_user1 = FactoryBot.create(:workspace_user, user_id: @user.id, workspace_id: @workspace1.id)
      @workspace2 = FactoryBot.create(:workspace)
      @workspace_user2 = FactoryBot.create(:workspace_user, user_id: @user.id, workspace_id: @workspace2.id)
    end

    context "success" do
      it 'can get workspaces' do
        get url, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['workspaces'].length).to eq(2)
        expect(res['workspaces'][0]['id']).to eq(@workspace1.id)
        expect(res['workspaces'][0]['name']).to eq(@workspace1.name)
        expect(res['workspaces'][0]['iconImageUrl']).to eq(@workspace1.icon_image_url)
        expect(res['workspaces'][0]['description']).to eq(@workspace1.description)
        expect(res['workspaces'][0]['coverImageUrl']).to eq(@workspace1.cover_image_url)
        expect(res['workspaces'][1]['id']).to eq(@workspace2.id)
        expect(res['workspaces'][1]['name']).to eq(@workspace2.name)
        expect(res['workspaces'][1]['iconImageUrl']).to eq(@workspace2.icon_image_url)
        expect(res['workspaces'][1]['description']).to eq(@workspace2.description)
        expect(res['workspaces'][1]['coverImageUrl']).to eq(@workspace2.cover_image_url)
      end
    end
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
      it 'can create workspace' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['workspace']['name']).to eq(body[:name])
        expect(res['workspace']['description']).to eq(body[:description])
        expect(res['workspace']['iconImageUrl']).to eq(body[:iconImageUrl])
        expect(res['workspace']['coverImageUrl']).to eq(body[:coverImageUrl])

        expect(WorkspaceUser.find_by(user_id: @user.id).workspace_id).to eq(res['workspace']['id'])
        expect(WorkspaceUser.find_by(workspace_id: res['workspace']['id']).user_id).to eq(@user.id)
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
    let(:url) { "/workspaces/#{workspace.id}" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        description: Faker::Name.name,
        iconImageUrl: Faker::Internet.url,
        coverImageUrl: Faker::Internet.url
      }
    end
    let(:workspace) { FactoryBot.create(:workspace) }

    context "success" do
      it 'can update workspace' do
        put url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['workspace']['name']).to eq(body[:name])
        expect(res['workspace']['description']).to eq(body[:description])
        expect(res['workspace']['iconImageUrl']).to eq(body[:iconImageUrl])
        expect(res['workspace']['coverImageUrl']).to eq(body[:coverImageUrl])
      end
    end

    context "error" do
      it 'can not update workspace without auth' do
        put url, params: body
        expect(response).to have_http_status 401
      end
    end
  end

  describe "POST /workspaces/:workspace_id/delete" do
    let(:workspace) { FactoryBot.create(:workspace) }
    let(:url) { "/workspaces/#{workspace.id}/delete" }
    let(:tokens) { get_auth_token(@user) }

    context "success" do
      it 'can delete workspace' do
        post url, headers: tokens
        expect(response).to have_http_status :ok
        expect(Workspace.find_by(id: workspace.id)).to be_blank
      end
    end

    context "error" do
      it 'cannot delete workspace' do
        post url
        expect(response).to have_http_status 401
      end
    end
  end

  describe "POST /workspaces/invite" do
    # 必要なもの
    # workspace(only user), workspaceUser(only user)
    # user(another, user)
    before(:each) do
      @workspace = FactoryBot.create(:workspace)
      @workspace1 = FactoryBot.create(:workspace)
      FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user.id)
      @another = FactoryBot.create(:user)
    end

    let(:token) { get_auth_token(@user) }
    let(:url) { "/workspaces/invite/" }

    context "success" do
      let(:body) do
        {
          user_id: @user.id,
          workspace_id: @workspace.id,
          email: @another.email
        }
      end

      it "can invite" do
        post url, params: body, headers: token
        expect(response).to have_http_status :ok

        res = JSON.parse(response.body)
        expect(res["user_id"]).to eq(@another.id)
        expect(res["workspace_id"]).to eq(@workspace.id)
      end
    end

    context "error" do
      let(:body) do
        {
          user_id: @user.id,
          workspace_id: @workspace1.id,
          email: @another.email
        }
      end

      it "cannot invite" do
        post url, params: body, headers: token
        expect(response).to have_http_status 401
      end
    end
  end
end
