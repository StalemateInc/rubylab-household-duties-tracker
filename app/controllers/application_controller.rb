class ApplicationController < ActionController::Base

  before_action :set_locale

  def after_sign_in_path_for(resource)
    groups_path
  end

  def after_sign_out_path(resource)
    index_path
  end

  def set_locale
    I18n.locale = cookies[:locale] || current_user.try(:locale) || I18n.default_locale
  end

end
