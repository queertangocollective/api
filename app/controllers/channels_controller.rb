class ChannelsController < ApplicationController
  before_action :authorize, only: [:create, :update, :destroy]
end
