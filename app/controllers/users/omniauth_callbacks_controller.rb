class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def webmoney
    # You need to implement the method below in your model
    @user = User.find_for_webmoney_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Webmoney"
      Rails.logger.info("#################### #{request.env.inspect}")
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.webmoney_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end