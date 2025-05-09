# config/initializers/openai.rb

OpenAI.configure do |config|
	# config.access_token = ENV.fetch(ENV["OPENAI_API_KEY"])
	config.access_token = ENV["OPENAI_API_KEY"]
end
