class ApplicationController < ActionController::Base
  require 'ipaddr'
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def restrict_non_usa_ips
	forwarded_ips = request.headers['X-Forwarded-For']
	user_ip = if forwarded_ips.present?
				user_ip = forwarded_ips.split(',').first.strip
			  else
				user_ip = request.remote_ip
			  end
	
	result = Geocoder.search(user_ip).first
	country_code = result&.country_code

	unless country_code == 'US'
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
