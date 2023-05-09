require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    @workspace_user = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user.id)
    @category = FactoryBot.create(:category, workspace_id: @workspace.id)
    @room = FactoryBot.create(:room, category_id: @category.id, workspace_id: @workspace.id)
    @room_user = FactoryBot.create(:room_user, room_id: @room.id, user_id: @user.id)

    @category1 = FactoryBot.create(:category, workspace_id: @workspace.id)
    @category2 = FactoryBot.create(:category, workspace_id: @workspace.id)
    @room1 = FactoryBot.create(:room, category_id: @category1.id, workspace_id: @workspace.id)
    @room_user1 = FactoryBot.create(:room_user, room_id: @room1.id, user_id: @user.id)
    @room2 = FactoryBot.create(:room, category_id: @category1.id, workspace_id: @workspace.id)
    @room_user2 = FactoryBot.create(:room_user, room_id: @room2.id, user_id: @user.id)
    @room3 = FactoryBot.create(:room, category_id: @category2.id, workspace_id: @workspace.id)
    @room_user3 = FactoryBot.create(:room_user, room_id: @room3.id, user_id: @user.id)
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
        # expect(RoomUser.find_by(user_id: @user.id).room_id).to eq(res['data']['room']['id'])
        expect(RoomUser.find_by(room_id: res['data']['room']['id']).user_id).to eq(@user.id)
      end
    end

    context "error" do
      it 'can not create room without auth' do
        post url, params: body
        expect(response).to have_http_status 401
      end
    end
  end

  describe "GET /rooms/{workspace_id}" do
    let(:url) { "/rooms" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        workspaceId: @workspace.id
      }
    end

    context "success" do
      it 'can show rooms' do
        get url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)

        categories = Category.where(workspace_id: @workspace.id)
        room_ids = RoomUser.where(user_id: @user.id).pluck(:id)

        expect(res['data']['categories'].size).to eq(categories.length)
        categories.each_with_index do |category, i|
          expect(category.id).to eq(res['data']['categories'][i]['id'])
          expect(category.name).to eq(res['data']['categories'][i]['name'])

          rooms = Room.where(id: room_ids).where(category_id: category.id).where(is_deleted: false)

          expect(res['data']['categories'][i]['rooms'].size).to eq(rooms.length)
          rooms.each_with_index do |room, j|
            expect(room.id).to eq(res['data']['categories'][i]['rooms'][j]['id'])
            expect(room.name).to eq(res['data']['categories'][i]['rooms'][j]['name'])
          end
        end
      end

      it 'ワークスペースにルームが存在しない' do
        @workspace_other = FactoryBot.create(:workspace)
        @user_other = FactoryBot.create(:user)
        @workspace_user = FactoryBot.create(:workspace_user, workspace_id: @workspace_other.id, user_id: @user_other.id)
        params = {
          workspaceId: @workspace_other.id
        }
        get url, params:, headers: get_auth_token(@user_other)
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['data']['categories']).to be_blank
      end

      it 'ユーザーが所属しているルームが存在しない' do
        @user_other = FactoryBot.create(:user)
        @workspace_user = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user_other.id)
        get url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)

        categories = Category.where(workspace_id: @workspace.id)
        room_ids = RoomUser.where(user_id: @user_other.id).pluck(:id)

        expect(res['data']['categories'].size).to eq(categories.length)
        categories.each_with_index do |category, i|
          expect(category.id).to eq(res['data']['categories'][i]['id'])
          expect(category.name).to eq(res['data']['categories'][i]['name'])

          rooms = Room.where(id: room_ids).where(category_id: category.id).where(is_deleted: false)

          expect(res['data']['categories'][i]['rooms'].size).to eq(rooms.length)
          rooms.each_with_index do |room, j|
            expect(room.id).to eq(res['data']['categories'][i]['rooms'][j]['id'])
            expect(room.name).to eq(res['data']['categories'][i]['rooms'][j]['name'])
          end
        end
      end
    end

    context "error" do
      it 'can not show room without auth' do
        get url, params: body
        expect(response).to have_http_status 401
      end

      it 'you are not belong to this workspace' do
        @user_other = FactoryBot.create(:user)
        get url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 401
        res = JSON.parse(response.body)
        expect("あなたはこのワークスペースに属していません").to eq(res['error']['text'])
      end
    end
  end
end
