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

    categories.each_with_index do |category, i|
      each_category[i][:rooms] = Room.where(category_id: category.id, is_deleted: false).order(id: :desc)
    end
    render status: 200, json: { 'categories' => each_category }, each_serializer: CategorySerializer
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
    workspace_id = Room.find_by(id: params[:room_id]).workspace_id

    if exist_user?(params[:email])
      render status: 400, json: { error: { text: "そのユーザーは存在しません" } }
      return
    end

    invited_user = User.find_by_email(params[:email])

    if guest_belong_to_workspace?(workspace_id, invited_user.id)
      # render status: 400, json: { error: { text: "そのユーザーはこのワークスペースに属していません" } }
      WorkspaceUser.create!(user_id: invited_user.id, workspace_id: workspace_id)
      # return
    end

    if exist_room?(params[:room_id])
      render status: 400, json: { error: { text: "そのルームは存在していません" } }
      return
    end

    unless guest_belong_to_room?(params[:room_id], invited_user.id)
      render status: 400, json: { error: { text: "そのユーザーはすでにこのルームに所属しています" } }
      return
    end

    RoomUser.create!({
                       room_id: params[:room_id],
                       user_id: invited_user.id
                     })
    render status: 200, json: { success: true }
  end

  def remove
    if exist_room?(params[:room_id])
      render status: 400, json: { error: { text: "そのルームは存在していません" } }
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
    params.permit(:room_id)
  end

  def update_params
    params.permit(:name, :description, :category_id)
  end

  def delete_params
    params.permit(:room_id)
  end

  def invite_params
    params.permit(:room_id, :email)
  end

  def remove_params
    params.permit(:room_id, user_id: [])
  end
end
