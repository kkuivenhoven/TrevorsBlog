class ApplicationController < ActionController::Base
  require 'ipaddr'
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Redirect after sign-out
  def after_sign_out_path_for(resource_or_scope)
	root_path
  end

  def after_sign_in_path_for(resource_or_scope)
	root_path
  end

  def after_sign_up_path_for(resource)
	root_path
  end

end
