=begin
begin
	Recaptcha.configure do |config|
		config.site_key = "#{ENV['RECAPTCHA_SITE_KEY']}"
		config.secret_key = "#{ENV['RECAPTCHA_SECRET_KEY']}"
		# config.api_server_url = 'https://www.google.com/recaptcha/api.js'
		# config.api_verification_url = 'https://www.google.com/recaptcha/api/siteverify'
		# config.skip_verify_env << 'development' # if you want to bypass locally
        # config.handle_timeouts_gracefully = true
		puts "--- INSIDE RECAPTCHA CONFIG ---"
		# config.proxy = 'http://localhost:3000'
	end

	puts ">> RECAPTCHA INITIALIZER LOADED"
rescue => e
	puts ">> FAILED TO LOAD RECAPTCHA INITIALIZER: #{e.message}"
end

=end
