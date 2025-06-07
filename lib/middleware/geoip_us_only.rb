class GeoIpUsOnly

	def initialize(app)
		@app = app
	end

	def call(env)
		req = Rack::Request.new(env)
		ip = (req.get_header('HTTP_X_FORWARDED_FOR') || req.ip).split(',').first

		location = Geocoder.search(ip).first
		country = location ? location.country_code : nil

		if country == 'US'
			@app.call(env)
		else
			[404, { 'Content-Type' => 'text/html' }, ['Not Found']]
		end
	end
end
