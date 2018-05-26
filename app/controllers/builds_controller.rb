require 'net/http'

class BuildsController < ApplicationController
  before_action :authorize, except: [:create]

  # Builds are verified by public keys, not authorizations
  def create
    build = group.builds.new(create_params)
    if build.verify && build.save
      # Activate this build
      group.current_build.update_attributes(live: false)
      build.live = true
      build.live_at = DateTime.now
      build.save
      group.current_build = build
      group.save
      head :ok
    else
      build.errors[:base] << 'No access - invalid SSH key' if !build.verify
      render(
        text: 'Could not create the build ' + build.errors.full_messages.to_s,
        status: :unprocessable_entity
      )
    end
  end

  private

  def api_key
    params[:api_key] || super
  end

  def create_params
    params.permit(:git_sha, :git_url, :html, :signature)
  end

end
