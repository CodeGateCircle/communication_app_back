require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @workspace = FactoryBot.create(:workspace)
    @workspace_user = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user.id)
    @category = FactoryBot.create(:category, workspace_id: @workspace.id)
    @room = FactoryBot.create(:room, category_id: @category.id, workspace_id: @workspace.id)
    @room_user = FactoryBot.create(:room_user, room_id: @room.id, user_id: @user.id)
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
        expect(res['room']['name']).to eq(body[:name])
        expect(res['room']['description']).to eq(body[:description])
        expect(res['room']['categoryId']).to eq(body[:categoryId])
        expect(res['room']['workspaceId']).to eq(body[:workspaceId])
        expect(RoomUser.where(room_id: res['room']['id'], user_id: @user.id).length).to eq(1)
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
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        workspace_id: @workspace.id
      }
    end
    let(:url) { "/rooms/#{@workspace.id}" }

    before(:each) do
      @category1 = FactoryBot.create(:category, workspace_id: @workspace.id)
      @category2 = FactoryBot.create(:category, workspace_id: @workspace.id)
      @room1 = FactoryBot.create(:room, category_id: @category1.id, workspace_id: @workspace.id)
      @room1_user = FactoryBot.create(:room_user, room_id: @room1.id, user_id: @user.id)
      @room2 = FactoryBot.create(:room, category_id: @category1.id, workspace_id: @workspace.id)
      @room2_user = FactoryBot.create(:room_user, room_id: @room2.id, user_id: @user.id)
      @room3 = FactoryBot.create(:room, category_id: @category2.id, workspace_id: @workspace.id)
      @room3_user = FactoryBot.create(:room_user, room_id: @room3.id, user_id: @user.id)
    end

    context "success" do
      it 'can show rooms' do
        get url, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)

        categories = Category.where(workspace_id: @workspace.id).order(id: :desc)
        room_ids = RoomUser.where(user_id: @user.id).order(id: :desc).pluck(:room_id)

        expect(res['categories'].length).to eq(categories.length)
        categories.each_with_index do |category, i|
          expect(category.id).to eq(res['categories'][i]['id'])
          expect(category.name).to eq(res['categories'][i]['name'])

          rooms = Room.where(id: room_ids, category_id: category.id, is_deleted: false).order(id: :desc)

          expect(res['categories'][i]['rooms'].length).to eq(rooms.length)
          rooms.each_with_index do |room, j|
            expect(room.id).to eq(res['categories'][i]['rooms'][j]['id'])
            expect(room.name).to eq(res['categories'][i]['rooms'][j]['name'])
          end
        end
      end

      it 'ワークスペースにルームが存在しない' do
        @workspace_other = FactoryBot.create(:workspace)
        @workspace_other_user = FactoryBot.create(:workspace_user, workspace_id: @workspace_other.id, user_id: @user.id)
        body_other = {
          workspace_id: @workspace_other.id
        }
        let(:url) { "/rooms/#{@workspace_other.id}" }
        get url, params: body_other, headers: get_auth_token(@user)
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['categories'].length).to eq(0)
      end

      it 'ユーザーが所属しているルームが存在しない' do
        @user_other = FactoryBot.create(:user)
        @workspace_user_other = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user_other.id)
        get url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)

        categories = Category.where(workspace_id: @workspace.id).order(id: :desc)
        room_ids = RoomUser.where(user_id: @user_other.id).order(id: :desc).pluck(:room_id)
        expect(res['categories'].length).to eq(categories.length)
        categories.each_with_index do |category, i|
          expect(category.id).to eq(res['categories'][i]['id'])
          expect(category.name).to eq(res['categories'][i]['name'])

          rooms = Room.where(id: room_ids, category_id: category.id, is_deleted: false).order(id: :desc)

          expect(res['categories'][i]['rooms'].length).to eq(rooms.length)
          rooms.each_with_index do |room, j|
            expect(room.id).to eq(res[i]['rooms'][j]['id'])
            expect(room.name).to eq(res[i]['rooms'][j]['name'])
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
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("あなたはこのワークスペースに属していません").to eq(res['error']['text'])
      end
    end
  end

  describe "POST /rooms/:room_id/delete" do
    let(:url) { "/rooms/#{@room.id}/delete" }
    let(:tokens) { get_auth_token(@user) }
    before(:each) do
      @deleted_room = FactoryBot.create(:room, is_deleted: true, category_id: @category.id, workspace_id: @workspace.id)
      @deleted_room_user = FactoryBot.create(:room_user, room_id: @deleted_room.id, user_id: @user.id)
    end
    context "success" do
      it 'can delete room' do
        post url, headers: tokens
        expect(response).to have_http_status :ok
        expect(Room.find_by(id: @room.id).is_deleted).to eq(true)
        expect(Room.find_by(id: @room.id).category_id).to eq(nil)
      end
    end

    context "error" do
      it 'can not delete room without auth' do
        post url
        expect(response).to have_http_status 401
      end

      it 'you are not belong to this room' do
        @user_other = FactoryBot.create(:user)
        post url, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("あなたはこのルームに属していません").to eq(res['error']['text'])
      end
    end
  end

  describe "PUT /rooms/:room_id" do
    let(:url) { "/rooms/#{@room.id}" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        name: Faker::Name.name,
        description: Faker::Name.name,
        categoryId: @category1.id
      }
    end
    before(:each) do
      @category1 = FactoryBot.create(:category, workspace_id: @workspace.id)
    end
    context "success" do
      it 'can update room' do
        put url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        res = JSON.parse(response.body)
        expect(res['room']['id']).to eq(@room.id)
        expect(res['room']['name']).to eq(body[:name])
        expect(res['room']['description']).to eq(body[:description])
        expect(res['room']['categoryId']).to eq(body[:categoryId])
        expect(res['room']['workspaceId']).to eq(@room.workspace_id)
      end
    end

    context "error" do
      it 'can not update room without auth' do
        put url, params: body
        expect(response).to have_http_status 401
      end

      it 'you are not belong to this room' do
        @user_other = FactoryBot.create(:user)
        put url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("あなたはこのルームに属していません").to eq(res['error']['text'])
      end
    end
  end

  describe "POST /rooms/:room_id/invite" do
    let(:url) { "/rooms/#{@room.id}/invite" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        userId: @user1.id
      }
    end
    before(:each) do
      @user1 = FactoryBot.create(:user)
      @workspace_user1 = FactoryBot.create(:workspace_user, workspace_id: @workspace.id, user_id: @user1.id)
      @deleted_room = FactoryBot.create(:room, is_deleted: true, category_id: @category.id, workspace_id: @workspace.id)
      @deleted_room_user = FactoryBot.create(:room_user, room_id: @deleted_room.id, user_id: @user.id)
    end
    context "success" do
      it 'can invite room' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        expect(RoomUser.where(room_id: @room.id, user_id: @user1.id).length).to eq(1)
      end
    end

    context "error" do
      it 'can not invite room without auth' do
        post url, params: body
        expect(response).to have_http_status 401
      end
      it 'you are not belong to this room' do
        @user_other = FactoryBot.create(:user)
        post url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("あなたはこのルームに属していません").to eq(res['error']['text'])
      end
      it 'this user is not belong to this workspace' do
        @user_other = FactoryBot.create(:user)
        body_other = {
          userId: @user_other.id
        }
        post url, params: body_other, headers: get_auth_token(@user)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("そのユーザーはこのワークスペースに属していません").to eq(res['error']['text'])
      end
      it 'this user is already belong to this room' do
        body_other = {
          userId: @user.id
        }
        post url, params: body_other, headers: get_auth_token(@user)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("そのユーザーはすでにこのルームに所属しています").to eq(res['error']['text'])
      end
      it 'this room is not exist' do
        url_other = "/rooms/#{@deleted_room.id}/invite"
        post url_other, params: body, headers: get_auth_token(@user)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("そのルームは存在していません").to eq(res['error']['text'])
      end
    end
  end

  describe "POST /rooms/:room_id/remove" do
    let(:url) { "/rooms/#{@room.id}/remove" }
    let(:tokens) { get_auth_token(@user) }
    let(:body) do
      {
        userId: [@user_a.id, @user_b.id, @user_c.id]
      }
    end
    before(:each) do
      @user_a = FactoryBot.create(:user)
      @room_user_a = FactoryBot.create(:room_user, room_id: @room.id, user_id: @user_a.id)
      @user_b = FactoryBot.create(:user)
      @room_user_b = FactoryBot.create(:room_user, room_id: @room.id, user_id: @user_b.id)
      @user_c = FactoryBot.create(:user)
      @room_user_c = FactoryBot.create(:room_user, room_id: @room.id, user_id: @user_c.id)
      @user_d = FactoryBot.create(:user)
      @room_user_d = FactoryBot.create(:room_user, room_id: @room.id, user_id: @user_d.id)
      @deleted_room = FactoryBot.create(:room, is_deleted: true, category_id: @category.id, workspace_id: @workspace.id)
      @deleted_room_user = FactoryBot.create(:room_user, room_id: @deleted_room.id, user_id: @user.id)
    end
    context "success" do
      it 'can remove room' do
        post url, params: body, headers: tokens
        expect(response).to have_http_status :ok
        expect(RoomUser.where(room_id: @room.id, user_id: @user.id)[0].id).to eq(@room_user.id)
        expect(RoomUser.where(room_id: @room.id, user_id: @user_a.id)).to be_blank
        expect(RoomUser.where(room_id: @room.id, user_id: @user_b.id)).to be_blank
        expect(RoomUser.where(room_id: @room.id, user_id: @user_c.id)).to be_blank
        expect(RoomUser.where(room_id: @room.id, user_id: @user_d.id)[0].id).to eq(@room_user_d.id)
      end
    end

    context "error" do
      it 'can not remove room without auth' do
        post url, params: body
        expect(response).to have_http_status 401
      end

      it 'you are not belong to this room' do
        @user_other = FactoryBot.create(:user)
        post url, params: body, headers: get_auth_token(@user_other)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("あなたはこのルームに属していません").to eq(res['error']['text'])
      end
      it 'this room is not exist' do
        url_other = "/rooms/#{@deleted_room.id}/remove"
        post url_other, params: body, headers: get_auth_token(@user)
        expect(response).to have_http_status 400
        res = JSON.parse(response.body)
        expect("そのルームは存在していません").to eq(res['error']['text'])
      end
    end
  end
end
