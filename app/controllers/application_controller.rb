class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :touch_active_at
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:username, :name, :language_id]
    devise_parameter_sanitizer.for(:account_update) << [:username, :name, :language_id]
  end

  def touch_active_at
    current_user.update_attribute(:last_active_at, Time.now) if current_user
  end
end
