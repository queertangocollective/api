require 'net/http'

class AuthorizationSessionsController < ApplicationController

  def create
    params = JSON.parse(request.body.read)

    # Clean up any expired authorizations
    AuthorizationSession.where("expires_at <= ?", Time.now).destroy_all

    if params['provider'] == 'email'
      authorizations = Authorization.where(email: params['email'])
      if authorizations.count > 0
        authorization = authorizations.first
        uid = SecureRandom.uuid
        token = SecureRandom.uuid

        authorization.update_attributes(
          uid: uid,
          provider: 'email'
        )

        session = authorization.authorization_sessions.create(
          activated: false,
          expires_at: DateTime.now + 5.minutes,
          session_id: Digest::SHA2.new(512).hexdigest(token)
        )
        authorization.update_tracked_fields(request)
        authorization.save

        LoginMailer.send_magic_link(authorization, token, params['redirect-uri']).deliver!

        head :ok
      else
        head :unauthorized
      end
      return
    end


    info = case params['provider']
           when 'google'
             authenticate_with_google(params)
           when 'facebook'
             authenticate_with_facebook(params)
           end

    authorization = Authorization.from_oauth(info)

    if authorization
      token = SecureRandom.uuid
      authorization.update_tracked_fields(request)
      authorization.save
      session = authorization.authorization_sessions.create(
        activated: true,
        expires_at: DateTime.now + 1.week + 12.hours,
        session_id: Digest::SHA2.new(512).hexdigest(token)
      )

      render json: {
               data: {
                 type: 'authorization-session',
                 attributes: {
                   'id': session.id,
                   'person-id': authorization.person_id,
                   'authorization-id': authorization.id,
                   'access-token': token
                 }
               }
             }
    else
      head :unauthorized
    end
  end

  def index
    token = request.headers['Access-Token']
    session = AuthorizationSession.where(
      "session_id = ? AND expires_at > ?",
      Digest::SHA2.new(512).hexdigest(token),
      DateTime.now
    ).first

    if session
      unless session.activated
        session.update_attributes(
          activated: true,
          expires_at: DateTime.now + 1.week + 12.hours
        )
      end

      render json: {
               data: {
                 type: 'authorization-session',
                 attributes: {
                   'id': session.id,
                   'person-id': session.authorization.person_id,
                   'authorization-id': session.authorization_id,
                   'access-token': token
                 }
               }
             }
    else
      head :not_found
    end
  end

  def destroy
    session = AuthorizationSession.find_by_session_id(
      Digest::SHA2.new(512).hexdigest(params[:id])
    )
    if session
      session.authorization.update_tracked_fields(request)
      session.destroy
      head :no_content
    else
      head :not_found
    end
  end

  private

  def fetch(url, options)
    if options[:method] == 'post'
      uri = URI(url)
      data = options[:data].stringify_keys
      JSON.parse(Net::HTTP.post_form(uri, data).body, symbolize_names: true)
    else
      uri = URI("#{url}?#{options[:data].to_query}")
      JSON.parse(Net::HTTP.get(uri), symbolize_names: true)
    end
  end

  def authenticate_with_facebook(params)
    response = fetch('https://graph.facebook.com/v2.8/oauth/access_token',
                     data: {
                       client_id: ENV['FACEBOOK_KEY'],
                       client_secret: ENV['FACEBOOK_SECRET'],
                       code: params['code'],
                       redirect_uri: params['redirect-uri']
                     })

    user = fetch('https://graph.facebook.com/me',
                 data: {
                   access_token: response[:access_token],
                   fields: 'email,name'
                 })
    {
      uid: user[:id],
      provider: 'facebook',
      name: user[:name],
      image: "https://graph.facebook.com/#{user[:id]}/picture?width=800",
      email: user[:email]
    }
  end

  def authenticate_with_google(params)
    response = fetch('https://www.googleapis.com/oauth2/v4/token',
                     method: 'post',
                     data: {
                       client_id: ENV['GOOGLE_CLIENT_ID'],
                       client_secret: ENV['GOOGLE_CLIENT_SECRET'],
                       code: params['code'],
                       redirect_uri: params['redirect-uri'],
                       grant_type: 'authorization_code'
                     })

    user = fetch('https://www.googleapis.com/oauth2/v3/userinfo',
                 data: {
                   access_token: response[:access_token]
                 })

    {
      uid: user[:sub],
      provider: 'google',
      name: user[:name],
      image: user[:picture],
      email: user[:email]
    }
  end

end
