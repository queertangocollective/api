class AuthorizationsController < ApplicationController
  before_action :authorize

  def authorize
    if current_user.try(:staff?)
      true
    else
      head :unauthorized
    end
  end
end
