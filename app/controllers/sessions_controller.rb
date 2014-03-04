class SessionsController < ApplicationController
  private
  def store_location
    session[:return_to] = request.fullpath
  end
end
