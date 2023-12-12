class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to_room?, only: %i[index]

  def index
    params = index_params
    messages = Room.find(params[:room_id]).messages.order("created_at DESC").page(params[:page]).per(20)
    if messages.blank?
      render status: 200, json: messages
      return
    end

    each_message = messages.map { |p| p.attributes.symbolize_keys }

    messages.each_with_index do |message, i|
      reactions = Reaction.where(message_id: message["id"]).order(name: :desc)
      each_message[i].store(:reactions, reactions)
      user = User.select(:id, :name, :email, :image).find(message["user_id"])
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

  private

  def index_params
    params.permit(:room_id, :page)
  end

  def post_params
    params.permit(:room_id, :content, :image, :page)
  end
end
