class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to_room?, only: %i[index]

  def index
    params = index_params
    messages = Room.find(params[:room_id]).messages.order("created_at DESC").page(params[:page]).per(20).preload(:reactions, :user)
    if messages.blank?
      render status: 200, json: messages
      return
    end

    each_message = messages.map { |p| p.attributes.symbolize_keys }

    messages.each_with_index do |message, i|
      reactions = message.reactions.order(name: :desc)
      each_message[i].store(:reactions, reactions)
      user = message.user.slice(:id, :name, :email, :image)
      each_message[i].store(:user, user)
      each_message[i].delete(:user_id)
    end

    render status: 200, json: { 'messages' => each_message }, each_serializer: MessageSerializer
    # render status: 200, json: each_messages, each_serializer: MessageSerializer
  end

  # TODO: "./profile_controller.rb" 参照
  def post
    params = post_params
    message = Message.create!({
                                room_id: params[:room_id],
                                user_id: current_user.id,
                                content: params[:content]
                              })
    if params[:image]
      path = preserve_image(params[:image], message.image_data)
      message.update!({ image: path })
    end

    render status: 200, json: message
  end

  def delete
    params = delete_params
    message = Message.find(params[:message_id])
    message.destroy!
    render status: 200, json: { success: true }
  end

  private

  def index_params
    params.permit(:room_id, :page)
  end

  def post_params
    params.permit(:room_id, :content, :image, :page)
  end

  def delete_params
    params.permit(:message_id)
  end
end
