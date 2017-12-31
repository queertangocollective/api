class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :current_user

  def context
    {
      current_user: current_user,
      group: group
    }
  end

  def current_authorization
    return @current_authorization if @current_authorization && access_token
    authorization_id = AuthorizationSession.find_by_session_id(access_token).try(:authorization_id)
    @current_authorization = group.authorizations.find(authorization_id) if authorization_id
  end

  def current_user
    return @current_user if @current_user
    @current_user = @current_authorization.try(:person)
  end

  def group
    Group.find_by_api_key(api_key)
  end

  def api_key
    request.headers['ApiKey'] || request.headers['Api-Key']
  end

  def access_token
    request.headers['AccessToken'] || request.headers['Access-Token']
  end

  def authorize
    if current_user.try(:staff?)
      true
    else
      head :unauthorized
    end
  end

  def not_found
    head :not_found
  end

  def internal_server_error
    head :internal_server_error
  end
end
