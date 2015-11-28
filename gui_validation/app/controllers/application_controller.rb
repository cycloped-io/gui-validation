class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user?

  protected
  def user?
    !current_user.nil?
  end

  def user_required
    unless user?
      redirect_to new_user_session_path
    end
  end
end
