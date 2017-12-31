class PostsController < ApplicationController
  prepend_before_filter :set_default_sort

  def set_default_sort
    unless params[:sort]
      params[:sort] = '-published-at'
    end
  end
end
