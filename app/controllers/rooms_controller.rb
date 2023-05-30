# room
class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to_workspace?, only: %i[create index]
  before_action :belong_to_room?, only: %i[update invite delete remove]

  def create
    Room.transaction do
      room = Room.create!(create_params)
      RoomUser.create!({ user_id: current_user.id, room_id: room[:id] })
      render status: 200, json: room, serializer: RoomSerializer
    end
  end

  def index
    categories = Category.where(index_params).order(id: :desc)
    if categories.blank?
      render status: 200, json: categories
      return
    end

    each_category = categories.map { |p| p.attributes.symbolize_keys }

    room_maps = Room.where(id: current_user.rooms, is_deleted: false).order(id: :desc)
    categories.each_with_index do |category, i|
      tmp = []
      room_maps.each_with_index do |room_map, _j|
        tmp.push(room_map.attributes.symbolize_keys) if room_map.category_id == category.id
      end
      each_category[i].store(:rooms, tmp)
    end
    render status: 200, json: each_category.to_json, each_serializer: CategorySerializer
  end

  def update
    room = Room.find(params[:room_id])
    room.update!(update_params)
    render status: 200, json: room, serializer: RoomSerializer
  end

  def delete
    Room.find(params[:room_id]).update!(is_deleted: true, category_id: nil)
    render status: 200, json: { success: true }
  end

  def invite
    workspace_id = Room.find(params[:room_id]).workspace_id
    if guest_belong_to_workspace?(workspace_id, params[:user_id])
      render status: 401, json: { error: { text: "そのユーザーはこのワークスペースに属していません" } }
      return
    end

    if exist_room?(params[:room_id])
      render status: 401, json: { error: { text: "そのルームは存在していません" } }
      return
    end

    unless guest_belong_to_room?(params[:room_id], params[:user_id])
      render status: 401, json: { error: { text: "そのユーザーはすでにこのルームに所属しています" } }
      return
    end

    RoomUser.create!(invite_params)
    render status: 200, json: { success: true }
  end

  def remove
    if exist_room?(params[:room_id])
      render status: 401, json: { error: { text: "そのルームは存在していません" } }
      return
    end

    RoomUser.where(remove_params).delete_all
    render status: 200, json: { success: true }
  end

  private

  # strong parameter
  def create_params
    params.permit(:name, :description, :category_id, :workspace_id)
  end

  def index_params
    params.permit(:workspace_id)
  end

  def update_params
    params.permit(:name, :description, :category_id)
  end

  def delete_params
    params.permit(:room_id)
  end

  def invite_params
    params.permit(:room_id, :user_id)
  end

  def remove_params
    params.permit(:room_id, user_id: [])
  end
end
