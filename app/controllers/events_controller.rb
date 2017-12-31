class EventsController < ApplicationController
  prepend_before_filter :set_default_sort

  def set_default_sort
    unless params[:sort]
      params[:sort] = '-starts-at,-ends-at'
    end
  end
end
