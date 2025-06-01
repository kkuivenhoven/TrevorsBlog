class ApplicationController < ActionController::Base
  require 'ipaddr'
  before_action :block_bad_ips
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
