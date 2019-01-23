class PostsController < ApplicationController
  before_action :authorize
  prepend_before_action :set_default_sort

  def set_default_sort
    unless params[:sort]
      params[:sort] = '-published-at'
    end
  end
end
