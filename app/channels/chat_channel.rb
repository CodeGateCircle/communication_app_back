class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params[:workspaceId]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def chat(data)
    message = Message.create!(
      room_id: data['roomId'],
      user_id: current_user.id,
      content: data['text']
    )

    message_data = message.attributes.symbolize_keys

    reactions = Reaction.where(message_id: message_data["id"]).order(name: :desc)
    message_data.store(:reactions, reactions)
    user = User.select(:id, :name, :email, :image).find(message_data["user_id"])
    message_data.store(:user, user)
    message_data.delete(:user_id)
    ActionCable.server.broadcast("chat_channel_#{message.room.workspace.id}", message_data)
  end

  def chat_delete(data)
    message = Message.find(data['messageId'])
    message.destroy!
    ActionCable.server.broadcast("chat_channel_#{message.room.workspace.id}", message)
  end

  def reaction_create(data)
    reaction = Reaction.create!(
      message_id: data['messageId'],
      user_id: current_user.id,
      name: data['name']
    )
    ActionCable.server.broadcast("chat_channel_#{reaction.message.room.workspace.id}", reaction)
  end

  def reaction_delete(data)
    reaction = Reaction.find_by(
      message_id: data['messageId'],
      user_id: current_user.id,
      name: data['name']
    )
    reaction.destroy!
    ActionCable.server.broadcast("chat_channel_#{reaction.message.room.workspace.id}", reaction)
  end
end
