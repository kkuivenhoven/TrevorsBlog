class BlockBadBots
	# Match known scrapers, CLI tools, script libraries
	BAD_BOTS = /curl|wget|httpclient|libwww-perl|python|scrapy|go-http-client|node-fetch|axios|java/i

	def initialize(app)
		@app = app
	end

	def call(env)
		user_agent = env["HTTP_USER_AGENT"].to_s
	
		if user_agent.match?(BAD_BOTS)
			Rails.logger.info "Blocked shady bot: #{user_agent}"
			return [404, { "Content-Type" => "text/plain" }, ["Not Found"]]
		end

		@app.call(env)
	end
end

Rails.application.config.middleware.insert_before 0, BlockBadBots
