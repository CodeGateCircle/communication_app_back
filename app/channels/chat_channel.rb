class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params[:roomId]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def chat(data)
    Message.create!(
      room_id: data['roomId'],
      user_id: current_user.id,
      content: data['text']
    )
    ActionCable.server.broadcast("chat_channel_#{data['roomId']}", data)
  end
end
