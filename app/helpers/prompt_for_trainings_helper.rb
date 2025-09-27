module PromptForTrainingsHelper

	def findPromptName(prompt_id)
		@promptCategory = Prompt.find(prompt_id)
		@promptCategory.title
	end

end
