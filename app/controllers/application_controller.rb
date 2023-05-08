# application
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :snake_to_camel_params

  def snake_to_camel_params
    params.deep_transform_keys!(&:underscore)
  end
end
