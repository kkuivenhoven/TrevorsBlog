class ApplicationController < ActionController::Base
  before_action :restrict_non_usa_ips, if: -> { Rails.env.production? }
  require 'ipaddr'
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def restrict_non_usa_ips
    user_ip = if request.headers['X-Forwarded-For'].present?
                request.headers['X-Forwarded-For'].split(',').first.strip
              else
                request.remote_ip
              end
	
	location = Geocoder.search(user_ip).first
	country_code = location&.country_code

	if country_code == 'US'
		Rails.logger.info "IP #{user_ip} from #{country_code}"
	else
		Rails.logger.info "Blocked IP: #{user_ip} from #{country_code}"
		# head :forbidden
		raise ActiveRecord::RecordNotFound 
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
