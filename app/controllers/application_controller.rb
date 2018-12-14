# coding: utf-8
class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :current_user

  def context
    {
      current_user: current_user,
      group: group,
      api_key: api_key
    }
  end

  def current_authorization
    return @current_authorization if @current_authorization && access_token
    authorization_id = AuthorizationSession.find_by_session_id(access_token).try(:authorization_id)
    @current_authorization = Authorization.find(authorization_id) if authorization_id
  end

  def current_user
    return @current_user if @current_user
    @current_user = current_authorization.try(:person)
  end

  def group
    return @group if @group

    if current_authorization
      @group = current_authorization.group
    else
      @group = Group.find_by_api_key(encrypted_api_key)
    end
  end

  def api_key
    request.headers['ApiKey'] || request.headers['Api-Key'] || ''
  end

  def encrypted_api_key
    Digest::SHA2.new(512).hexdigest(api_key)
  end

  def access_token
    Digest::SHA2.new(512).hexdigest(request.headers['AccessToken'] || request.headers['Access-Token'] || '')
  end

  def authorize
    if current_user.try(:staff?)
      true
    else
      head :unauthorized
    end
  end

  def health_check
    begin
      Group.first
      render plain: '❤️'
    rescue e
      render plain: '💔'
    end
  end

  def not_found
    head :not_found
  end

  def internal_server_error
    head :internal_server_error
  end
end
