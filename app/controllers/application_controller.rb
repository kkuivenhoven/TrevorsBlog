class ApplicationController < ActionController::Base
  require 'ipaddr'
  before_action :block_bad_ips, :restrict_non_usa_ips
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  BAD_IP_RANGES = [
	IPAddr.new('114.119.0.0/16'), # Huawei Cloud Service - China - suspicious bot activity
	IPAddr.new('103.136.220.0/24') # HostBangla - Bangladesh - suspicious bot activity
	# Can add more CIDR ranges or specific IPs id needed
  ]

  def block_bad_ips
	remote_ip = IPAddr.new(request.remote_ip)

	if BAD_IP_RANGES.any? { |ip_range| ip_range.include?(remote_ip) }
		head :forbidden
	end
  end

  def restrict_non_usa_ips
	fowarded_ips = request.headers['X-Forwarded-For'];
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
