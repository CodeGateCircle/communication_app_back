class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to_room?, only: %i[index]
  
  def index
    params = index_params
    messages = Room.find(params[:room_id]).messages
    render status: 200, json: messages, each_serializer: MessageSerializer
  end

  def post
    params = post_params
    message = Messages.create!({
                                 room_id: params[:room_id],
                                 user_id: current_user.id,
                                 content: params[:content]
                               })
    message.image.attach(params[:image]) if params[:image]
    render status: 200, json: message
  end

  private

  def index_params
    params.permit(:room_id)
  end

  def post_params
    params.permit(:room_id, :content, :image)
  end
end
