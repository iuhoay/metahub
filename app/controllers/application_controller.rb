class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :set_sentry_context
  after_action :verify_authorized, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :known_error
  rescue_from DatabaseConnectionError, with: :known_error

  protected

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path = nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end

  private

  def known_error(exception)
    flash[:alert] = exception.message
    redirect_to(request.referrer || root_path)
  end

  def set_sentry_context
    Sentry.set_user(id: current_user.id, name: current_user.name) if current_user
  end
end
