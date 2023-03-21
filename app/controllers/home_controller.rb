class HomeController < ApplicationController
  def index
  end
  skip_before_action :check_logged_in, only: :index
end