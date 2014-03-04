class ApplicationController < ActionController::Base
  class PermissionDenied < StandardError; end
  rescue_from CanCan::AccessDenied, :with => :access_denied
  rescue_from ActiveRecord::RecordInvalid do |e|
    flash[:error] = e.message
    redirect_to :back
  end
  #rescue_from CanCan::AccessDenied do |exception|
  #  redirect_to main_app.root_url, :alert => exception.message
  #end
private
  def access_denied
    flash[:warning] = t(:access_denied)
    redirect_to root_path
  end
end
