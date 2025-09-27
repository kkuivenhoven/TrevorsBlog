class RenamePromptsForTrainingsToPromptForTrainings < ActiveRecord::Migration[8.0]
  def change
	if table_exists?(:prompts_for_trainings)
		rename_table :prompts_for_trainings, :prompt_for_trainings
	else
		puts "Table prompts_for_trainings does not exist, skipping rename"
	end
  end
end
