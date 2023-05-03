require 'rails_helper'

RSpec.describe "Categories", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
  end
  describe "POST /categories" do
    let(:url) { "/categories" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        workspace_id: @workspace.id
      }
    end

    context "success" do
      it "can create category" do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok

        res = JSON.parse(response.body)
        expect(res['data']['category']['name']).to eq(body[:name])
        expect(res['data']['category']['workspace_id']).to eq(body[:workspace_id])
      end
    end
  end
end
