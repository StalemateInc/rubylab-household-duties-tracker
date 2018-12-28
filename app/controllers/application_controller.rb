class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    groups_path
  end

  def after_sign_out_path(resource)
    root_path
  end
end
