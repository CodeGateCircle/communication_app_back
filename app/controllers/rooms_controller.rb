# room
class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    params = params_int(create_params)

    Room.transaction do
      room = Room.create!({
                            name: params[:name],
                            description: params[:description],
                            category_id: params[:categoryId],
                            workspace_id: params[:workspaceId]
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

    if belong_to_workspace?(params[:workspace_id])
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

  private

  # strong parameter
  def create_params
    params.permit(:name, :description, :categoryId, :workspaceId)
  end

  def index_params
    params.permit(:workspace_id)
  end

  def delete_params
    params.permit(:roomId)
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
