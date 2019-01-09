class IndexController < ActionController::Base
  def change_locale
    locale = locale_valid? ? params[:locale] : I18n.default_locale
    cookies.permanent[:locale] = locale
    redirect_to request.referer || root_url
  end

  private

  def locale_valid?
    I18n.available_locales.include?(locale_params[:locale].to_sym)
  end

  def locale_params
    params.permit(:locale)
  end
end
