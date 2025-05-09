class FraudPromptsController < ApplicationController
	before_action :authenticate_user!

	def index 
		@fraud_prompts = current_user.fraud_prompts
	end

	def show
		@fraud_prompt = FraudPrompt.find(params[:id])
	end

	def new
		@fraud_prompt = FraudPrompt.new
	end

	def create
		@fraud_prompt = current_user.fraud_prompts.build(fraud_prompt_params)
		system_prompt = FraudPromptConfig::CONFIG[params["fraud_prompt"]["category"]]["prompt"]
		user_input = params["fraud_prompt"]["user_input"]
		begin
			client = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"])
			response = client.chat(
				parameters: {
					model: "gpt-4o-mini",
					messages: [
						{ role: "system", content: system_prompt },
						{ role: "user", content: user_input }
					],
					temperature: 0.2
				}
			)
			@fraud_prompt.result = response["choices"].first["message"]["content"]
			if @fraud_prompt.save
				redirect_to fraud_prompt_path(@fraud_prompt)
			else
				render :new
			end
		rescue OpenAI::Error => e
			flash[:error] = "There was an error with the OpenAI API: #{e.message}"
			render :new
		rescue => e
			flash[:error] = "An error occurred: #{e.message}"
		end
	end

	private 

	def fraud_prompt_params
		params.require(:fraud_prompt).permit(:category, :user_input)
	end

end
