class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def chat(data)
    ActionCable.server.broadcast('chat', { sender: current_user.name, body: data['body'] })
  end
end
