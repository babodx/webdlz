module SessionsHelper
  def store_location
    session[:return_to] = request.fullpath
  end


  def clear_stored_location
    session[:return_to] = nil
  end

  def after_sign_in_path_for(resource)
    return_to = request.env['omniauth.origin']
    Rasil.logger.info("$$$$$$$$$$#{request.env['omniauth.origin']}")
    stored_location_for(resource) || return_to || root_path
  end
end
