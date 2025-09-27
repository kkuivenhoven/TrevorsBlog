class RenamePromptsForTrainingsToPromptForTrainings < ActiveRecord::Migration[8.0]
  def change
	rename_table :prompts_for_trainings, :prompt_for_trainings
  end
end
