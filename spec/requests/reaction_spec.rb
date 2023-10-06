require 'rails_helper'

RSpec.describe "Reactions", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    @workspace_user = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user.id)
    @category = FactoryBot.create(:category, workspace_id: @workspace.id)
    @room = FactoryBot.create(:room, category_id: @category.id, workspace_id: @workspace.id)
    @room_user = FactoryBot.create(:room_user, room_id: @room.id, user_id: @user.id)
    @message = FactoryBot.create(:message, room_id: @room.id, user_id: @user.id)
  end

  # describe "POST /reactions" do
  #   let(:url) { "/reactions" }
  #   let(:tokens) { get_auth_token(@user) }
  #   let(:body) do
  #     {
  #       name: Faker::Name.name,
  #       messageId: @message.id
  #     }
  #   end

  #   context "success" do
  #     it 'can create reaction' do
  #       post url, params: body, headers: tokens
  #       expect(response).to have_http_status :ok
  #       res = JSON.parse(response.body)
  #       expect(res['reaction']['name']).to eq(body[:name])
  #       expect(res['reaction']['messageId']).to eq(body[:messageId])
  #       expect(res['reaction']['userId']).to eq(@user.id)
  #     end
  #   end

  #   context "error" do
  #     it 'can not create reaction without auth' do
  #       post url, params: body
  #       expect(response).to have_http_status 401
  #     end
  #   end
  # end

  describe "GET /reactions" do
    let(:url) { "/reactions" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        message_id: @message.id
      }
    end
    let(:other_message) { FactoryBot.create(:message, room_id: @room.id, user_id: @user.id) }
    let!(:reaction) { FactoryBot.create_list(:reaction, 10, message_id: @message.id, user_id: @user.id) }
    let!(:other_reaction) { FactoryBot.create_list(:reaction, 15, message_id: other_message.id, user_id: @user.id) }

    context "success" do
      it "can get reactions" do
        get url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['reactions'].size).to eq(10)
        expect(res['reactions']).to match_array(lower_camel_key_hash(reaction.map(&:as_json)))
      end
    end

    context "error" do
      it "cannot get reactions without auth" do
        get url, params: body
        expect(response).to have_http_status 401
      end
    end
  end

  describe "POST /reactions/delete" do
    let(:url) { "/reactions/delete" }
    let(:tokens) { get_auth_token(@user) }
    let(:reaction) { FactoryBot.create(:reaction, message_id: @message.id, user_id: @user.id) }
    let(:body) do
      {
        name: reaction.name,
        messageId: reaction.message_id
      }
    end
    context "success" do
      it 'can delete reaction' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        expect(Reaction.find_by(id: reaction.id)).to be_blank
      end
    end

    context "error" do
      it 'cannot delete reaction' do
        post url, params: body
        expect(response).to have_http_status 401
      end
    end
  end
end
