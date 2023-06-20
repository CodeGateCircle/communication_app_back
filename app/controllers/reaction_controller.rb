class ReactionController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to_workspace?, only: %i[]
  before_action :belong_to_room?, only: %i[]

  def create
    params = create_params

  end

  private

  # strong parameter
  def create_params
    params.permit(:message_id)
  end
end
