class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :store_current_location, :unless => :devise_controller?

  private

  def store_current_location
    if params[:redirect_to].present?
      store_location_for(:user, params[:redirect_to])    
    else
      store_location_for(:user, request.url)
    end    
  end
end
