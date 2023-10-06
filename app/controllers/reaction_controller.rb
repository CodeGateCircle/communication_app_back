class ReactionController < ApplicationController
  before_action :authenticate_user!

  # def create
  #   params = create_params
  #   reaction = Reaction.create!({ message_id: params[:message_id], user_id: current_user.id, name: params[:name] })
  #   render status: 200, json: reaction
  # end

  def index
    reactions = Reaction.where(index_params).order(name: :desc)
    render status: 200, json: reactions, each_serializer: ReactionSerializer
  end

  def delete
    params = delete_params
    reaction = Reaction.find_by(message_id: params[:message_id], name: params[:name], user_id: current_user.id)
    reaction.destroy!
    render status: 200, json: { success: true }
  end

  private

  # strong parameter
  def create_params
    params.permit(:message_id, :name)
  end

  def index_params
    params.permit(:message_id)
  end

  def delete_params
    params.permit(:message_id, :name)
  end
end
