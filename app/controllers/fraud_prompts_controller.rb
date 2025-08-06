class FraudPromptsController < ApplicationController
	before_action :authenticate_user!

	def index 
		@fraud_prompts = current_user.fraud_prompts
	end

	def show
		@fraud_prompt = FraudPrompt.find(params[:id])
		@prompt = Prompt.find(@fraud_prompt.prompt_id)
	end

	def new
		@fraud_prompt = FraudPrompt.new
		@prompts = Prompt.all
		Rails.logger.info "Hit the FraudPrompt::new method"
	end

	# create method
	def create
		Rails.logger.info "Hit the FraudPrompt::create method"
		prompt_id = params[:fraud_prompt][:prompt_id]
		@prompt = Prompt.find(prompt_id)
		system_prompt = @prompt.system_message
		@fraud_prompt = current_user.fraud_prompts.build(fraud_prompt_params)
		user_input = params["fraud_prompt"]["user_input"]
		Rails.logger.info "Before begin in FraudPrompt::create method"
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
			@fraud_prompt.prompt_id = prompt_id
			@fraud_prompt.result = response["choices"].first["message"]["content"]
			Rails.logger.info " BEFORE THE @FRAUD PROMPT SAVE"
			if @fraud_prompt.save
				Rails.logger.info "fraud prompt should've saevd in def create"
				redirect_to fraud_prompt_path(@fraud_prompt)
			else
				Rails.logger.info "fraud prompt DID NOT save"
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
		params.require(:fraud_prompt).permit(:user_input, :prompt_id)
	end

end
