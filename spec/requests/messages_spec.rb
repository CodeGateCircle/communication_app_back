require 'rails_helper'

RSpec.describe "Messages", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    FactoryBot.create(
      :workspace_user,
      workspace: @workspace,
      user: @user
    )
    @room = FactoryBot.create(:room, workspace: @workspace)
    FactoryBot.create(:room_user, room: @room, user: @user)
  end

  describe "GET /index" do
    let(:url) { "/messages?room_id=#{@room.id}" }
    let(:tokens) { get_auth_token(@user) }
    let(:other_room) { FactoryBot.create(:room, workspace: @workspace) }
    let!(:messages) { FactoryBot.create_list(:message, 10, room: @room) }
    let!(:other_messages) { FactoryBot.create_list(:message, 10, room: other_room) }

    context 'success' do
      it 'can get messages' do
        get url, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['messages'].length).to eq(10)
        expect(res['messages']).to match_array(lower_camel_key_hash(messages.map(&:as_json)))
      end
    end

    context "error" do
      it 'can not get messages without auth' do
        get url, params: body
        expect(response).to have_http_status 401
      end

      it 'you are not belong to this room' do
        @user_other = FactoryBot.create(:user)
        get url, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("あなたはこのルームに属していません").to eq(res['error']['text'])
      end
    end
  end
end
