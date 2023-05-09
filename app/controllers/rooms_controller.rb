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
    params = params_int(show_params)

    if belong_to_workspace?(params[:workspaceId])
      render status: 401, json: { error: { text: "あなたはこのワークスペースに属していません" } }
    else
      categories = Category.where(workspace_id: params[:workspaceId])
      # workspaceにroomがあるかどうかの確認
      if categories.blank?
        render status: 200, json: { data: { categories: } }
        return
      end
      rooms = categories.map(&:category_show_format_res)

      room_users = RoomUser.where(user_id: current_user.id).pluck(:id)
      rooms.each_with_index do |category, i|
        rooms[i].store('rooms', Room.where(id: room_users).where(category_id: category['id']).where(is_deleted: false).select(:id, :name).map(&:room_show_format_res))
      end

      render status: 200, json: { data: { categories: rooms } }
    end
  end

  private

  # strong parameter
  def create_params
    params.permit(:name, :description, :categoryId, :workspaceId)
  end

  def show_params
    params.permit(:workspaceId)
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
