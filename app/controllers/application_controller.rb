class ApplicationController < ActionController::Base
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t('cancancan.access_denied')
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path }
    end
  end

  def after_sign_in_path_for(resource)
    cookies[:locale] = I18n.locale if cookies[:locale].nil?
    groups_path
  end

  def after_sign_out_path(resource)
    index_path
  end

  def set_locale
    I18n.locale = cookies[:locale] || current_user.try(:locale) || I18n.default_locale
  end

end
