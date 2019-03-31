require 'net/http'

class OembedController < ApplicationController
  def get
    if params[:url].match(/youtube\.com/)
      render(
        json: HTTParty.get("https://www.youtube.com/oembed?url=#{params[:url]}&format=json", headers: {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        })
      )
    end
  end
end
