# Application Controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(*)
    flash[:message] = "Welcome #{current_user.name}!"
    access_path(current_user.id)
  end

  #  def default_url_options(options = {})
  #    { locale: I18n.locale }.merge options
  #  end

  def set_locale
    if params[:language] == 'en'
      cookies.permanent[:language] = 'en'
      locale = 'en'
    elsif params[:language] == 'ru'
      cookies.permanent[:language] = 'ru'
      locale = 'ru'
    elsif cookies[:language] == 'en'
      locale = 'en'
    elsif cookies[:language] == 'ru'
      locale = 'ru'
    elsif params[:locale] == 'en'
      locale = 'en'
    elsif params[:locale] == 'ru'
      locale = 'ru'
    end

    I18n.locale = locale || I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name,
               :phone,
               :email,
               :password,
               :password_confirmation,
               :remember_me)
    end
    # devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :email,
    # :password, :remember_me) }
    # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email,
    # :password, :password_confirmation, :current_password) }
  end

  private

  def user_not_authorized
    flash[:alert] = "You don't have permission for this operation"
    redirect_to root_path
  end
end
