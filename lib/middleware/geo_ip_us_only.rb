module Middleware
	class GeoIpUsOnly

		def initialize(app)
			@app = app
		end

		def call(env)
			req = Rack::Request.new(env)
			ip = (req.get_header('HTTP_X_FORWARDED_FOR') || req.ip).split(',').first

			location = Geocoder.search(ip).first
			country = location ? location.country_code : nil
		
			puts "[GeoIP Debug IP: #{ip}, Country: #{country}"
			Rails.logger.info "[GeoIP Debug IP: #{ip}, Country: #{country}"

			if local_ip?(ip) || country == 'US'
				@app.call(env)
			else
				head :not_found
			end
		end

		private
			def local_ip?(ip)
				ip == '127.0.0.1' || ip == '::1'
			end
	end
end
