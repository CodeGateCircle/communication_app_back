# application
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :snake_to_camel_params

  def snake_to_camel_params
    params.deep_transform_keys!(&:underscore)
  end

  # ユーザーがworkspaceに属しているかチェック
  def belong_to_workspace?
    return if WorkspaceUser.find_by(workspace_id: params[:workspace_id], user_id: current_user.id)

    render status: 400, json: { error: { text: "あなたはこのワークスペースに属していません" } }
    nil
  end

  # 自分以外のユーザーがworkspaceに属しているかチェック
  def guest_belong_to_workspace?(workspace_id, user_id)
    user = WorkspaceUser.find_by(workspace_id:, user_id:)
    user.nil?
  end

  # ユーザーがroomに属しているかチェック
  def belong_to_room?
    return if RoomUser.find_by(room_id: params[:room_id], user_id: current_user.id)

    render status: 400, json: { error: { text: "あなたはこのルームに属していません" } }
    nil
  end

  # 自分以外のユーザーがroomに属しているかチェック
  def guest_belong_to_room?(room_id, user_id)
    user = RoomUser.find_by(room_id:, user_id:)
    user.nil?
  end

  # ルームが存在しているかチェック
  def exist_room?(room_id)
    room = Room.find_by(id: room_id, is_deleted: false)
    room.nil?
  end

  # 画像を保存する
  def preserve_image(image_data, attach_element)
    if String(image_data).start_with?('http')
      url = URI.parse(image_data)
      nil if url.host.nil?
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      response = http.get(url.request_uri)

      io = StringIO.new(response.body)

      attach_element.attach(io:, filename: "#{current_user.name}_image")
    else
      attach_element.attach(image_data)
    end
    url_for(attach_element)
  end
end
