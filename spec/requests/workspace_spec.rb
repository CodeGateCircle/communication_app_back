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
      # it '有効なworkspaceの場合は保存される' do
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

        expect(WorkspaceUser.find_by(user_id: @user.id).workspace_id).to eq(res['data']['workspace']['id'])
        expect(WorkspaceUser.find_by(workspace_id: res['data']['workspace']['id']).user_id).to eq(@user.id)
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
        expect(res['data']['workspace']['name']).to eq(body[:name])
        expect(res['data']['workspace']['description']).to eq(body[:description])
        expect(res['data']['workspace']['iconImageUrl']).to eq(body[:iconImageUrl])
        expect(res['data']['workspace']['coverImageUrl']).to eq(body[:coverImageUrl])
      end
    end

    context "error" do
      it 'can not update workspace without auth' do
        put url, params: body
        expect(response).to have_http_status 401
      end
    end
  end

  describe "PUT /workspaces/:workspace_id/delete" do
    let(:workspace) { FactoryBot.create(:workspace) }
    let(:url) { "/workspaces/#{workspace.id}/delete"}
    let(:tokens) { get_auth_token(@user) }

    context "success" do
      it 'can delete workspace' do
        put url, headers: tokens
        expect(response).to have_http_status :ok
        expect(Workspace.find_by(id: workspace.id)).to be_blank
      end
    end

    context "error" do
      it 'cannot delete workspace' do
        put url
        expect(response).to have_http_status 401
      end
    end

  end
end
