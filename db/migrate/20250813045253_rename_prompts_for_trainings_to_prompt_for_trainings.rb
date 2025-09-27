class RenamePromptsForTrainingsToPromptForTrainings < ActiveRecord::Migration[8.0]
  def change
	if table_exists?(:prompts_for_trainings)
		puts "Table prompts_for_Trainings exists. Renaming..."
		rename_table :prompts_for_trainings, :prompt_for_trainings
		puts "Rename complete."
	else
		puts "Table prompts_for_trainings does not exist, skipping rename"
	end
  end
end
