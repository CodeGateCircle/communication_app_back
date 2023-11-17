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
        expect(res['messages']).to match_array(lower_camel_key_hash(messages.map { |message| MessageSerializer.new(message).as_json }))
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

  describe "POST /post" do
    let(:url) { "/messages?room_id=#{@room.id}" }
    let(:token) { get_auth_token(@user) }
    let(:body) do
      {
        content: Faker::Lorem.sentence,
        image: Faker::Avatar.image
      }
    end

    context 'success' do
      it 'can post message' do
        post url, params: body, headers: token
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['message']['roomId']).to eq(@room.id)
        expect(res['message']['content']).to eq(body[:content])
      end

      it 'can update profile upload image' do
        local_body = {
          content: Faker::Lorem.sentence,
          image: fixture_file_upload('spec/unnamed.jpg', 'image/jpg')
        }
        post url, params: local_body, headers: token
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['message']['roomId']).to eq(@room.id)
        expect(res['message']['content']).to eq(local_body[:content])
      end

      it 'can post message without image' do
        post url, params: body.except(:image), headers: token
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['message']['roomId']).to eq(@room.id)
        expect(res['message']['content']).to eq(body[:content])
        expect(res['message']['image']).to eq(nil)
      end
    end
  end
end
