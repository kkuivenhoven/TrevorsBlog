module FraudPromptHelper

	def getTitleForPrompt(prompt_id)
		prompt = Prompt.find_by(id: prompt_id)
		prompt.title
	end


end
