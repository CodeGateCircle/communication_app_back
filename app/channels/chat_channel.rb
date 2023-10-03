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
end
