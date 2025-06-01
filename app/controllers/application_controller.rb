class ApplicationController < ActionController::Base
  before_action
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  BAD_IPS = [
    '114.119.135.207',
    '114.119.151.155',
    # Add other suspicious IPs or IP ranges here
  ]

  def block_bad_ips
	if BAD_IPS.include?(request.remote_ip)
		head :forbidden
	end
  end

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
