class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  impersonates :user

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:names,
                                                       :code,
                                                       :last_names,
                                                       :country_id,
                                                       :state_id,
                                                       :phone,
                                                       :institution_id,
                                                       :institution_name,
                                                       :institution_type_id,
                                                       :institution_privacy_id])
  end

  private

  def user_not_authorized
    flash[:alert] = 'No tiene permiso para realizar esta acción'
    redirect_to "/"
  end

  def set_locale
    if current_user
      I18n.locale = current_user&.locale || :es
    else
      I18n.locale = params[:locale]
    end
  end
end
