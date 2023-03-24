class ApplicationController < ActionController::Base
  include SessionsHelper
  # before_action :check_logged_in

  protect_from_forgery

  def check_logged_in
    return if current_user

    text = { title: "ログインチェック"}
    render json: text
  end
end