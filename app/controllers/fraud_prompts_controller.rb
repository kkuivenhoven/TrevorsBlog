class FraudPromptsController < ApplicationController
	before_action :authenticate_user!
	protect_from_forgery with: :null_session # for JS POST

	def categorize
		# input = params[:user_input]
		user_input = params[:user_input]
		service = TfidfService.new
		result = service.cosine_similarity(user_input)
		prompt = Prompt.find_by(id: result)
		# render json: { result: result }
		render json: { result: prompt.title }
		#############################################
		### NEED TOOOO EXCLUDE STOP WORDS OKAY!!!!!###
		##############################################
		# best_match = 
		# compute cosine similarity
		# render json
	end

	def index 
		@fraud_prompts = current_user.fraud_prompts.order(created_at: :desc)
	end

	def show
		@fraud_prompt = FraudPrompt.find(params[:id])
		@prompt = Prompt.find(@fraud_prompt.prompt_id)
	end

	def new
		@fraud_prompt = FraudPrompt.new
		@prompts = Prompt.all
		@prompts.order(Arel.sql("CASE WHEN title = 'Not Sure' THEN 0 ELSE 1 END"), :title, :description)
	end

	# create method
	def create
		prompt_id = params[:fraud_prompt][:prompt_id]
		@prompt = Prompt.find(prompt_id)
		system_prompt = @prompt.system_message
		@fraud_prompt = current_user.fraud_prompts.build(fraud_prompt_params)
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
			@fraud_prompt.prompt_id = prompt_id
			@fraud_prompt.result = response["choices"].first["message"]["content"]
			if @fraud_prompt.save
				redirect_to fraud_prompt_path(@fraud_prompt)
			else
				render :new, status: :unprocessable_entity
			end
		rescue OpenAI::Error => e
			flash[:error] = "There was an error with the OpenAI API: #{e.message}"
			render :new, status: :unprocessable_entity
		rescue => e
			flash[:error] = "An error occurred: #{e.message}"
			render :new, status: :unprocessable_entity
		end
	end

	private 

	def fraud_prompt_params
		params.require(:fraud_prompt).permit(:user_input, :prompt_id)
	end

end
