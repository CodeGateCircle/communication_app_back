class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to_room?, only: %i[index]
  def index
    params = index_params
    messages = Room.find(params[:room_id]).messages
    render status: 200, json: messages, each_serializer: MessageSerializer
  end

  private

  def index_params
    params.permit(:room_id)
  end
end
