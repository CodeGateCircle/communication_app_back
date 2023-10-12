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
