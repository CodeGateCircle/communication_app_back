# room
class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    params = params_int(create_params)

    Room.transaction do
      room = Room.create!({
                            name: params[:name],
                            description: params[:description],
                            category_id: params[:category_id],
                            workspace_id: params[:workspace_id]
                          })

      room_user = RoomUser.new({
                                 user_id: current_user.id,
                                 room_id: room[:id]
                               })
      room_user.save!

      render status: 200, json: { data: { room: room.format_res } }
    end
  end

  def index
    params = params_int(index_params)

    if belong_to_workspace?(params[:workspace_id], current_user.id)
      render status: 401, json: { error: { text: "あなたはこのワークスペースに属していません" } }
    else
      categories = Category.where(workspace_id: params[:workspace_id]).order(id: "DESC")
      # workspaceにroomがあるかどうかの確認
      if categories.blank?
        render status: 200, json: { data: { categories: } }
        return
      end

      rooms = categories.map(&:category_show_format_res)

      room_maps = Room.where(id: current_user.rooms).where(is_deleted: false).order(id: "DESC")

      categories.each_with_index do |category, i|
        tmp = []
        room_maps.each_with_index do |room_map, _j|
          tmp.push(room_map.room_show_format_res) if room_map.category_id == category.id
        end
        rooms[i].store('rooms', tmp)
      end

      render status: 200, json: { data: { categories: rooms } }
    end
  end

  def update
    params = params_int(update_params)

    room = Room.find(params[:room_id])
    room.update!({
                   name: params[:name],
                   description: params[:description],
                   category_id: params[:category_id]
                 })

    render status: 200, json: room, serializer: RoomSerializer
  end

  def delete
    params = params_int(delete_params)

    if belong_to_room?(params[:room_id], current_user.id)
      render status: 401, json: { error: { text: "あなたはこのルームに属していません" } }
      return
    end

    Room.find(params[:room_id]).update!(is_deleted: true, category_id: nil)

    render status: 200, json: { success: true }
  end

  def invite
    params = params_int(invite_params)

    if belong_to_room?(params[:room_id], current_user.id)
      render status: 401, json: { error: { text: "あなたはこのルームに属していません" } }
      return
    end

    workspace_id = Room.find(params[:room_id]).workspace_id
    if belong_to_workspace?(workspace_id, params[:user_id])
      render status: 401, json: { error: { text: "そのユーザーはこのワークスペースに属していません" } }
      return
    end

    unless belong_to_room?(params[:room_id], params[:user_id])
      render status: 401, json: { error: { text: "そのユーザーはすでにこのルームに所属しています" } }
      return
    end

    RoomUser.create!({
                       room_id: params[:room_id],
                       user_id: params[:user_id]
                     })

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
    params.permit(:room_id, :name, :description, :category_id)
  end

  def delete_params
    params.permit(:room_id)
  end

  def invite_params
    params.permit(:room_id, :user_id)
  end

  # 整数値に変換
  def params_int(params)
    params.each do |key, value|
      params[key] = value.to_i if integer_string?(value)
    end
  end

  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end
end
