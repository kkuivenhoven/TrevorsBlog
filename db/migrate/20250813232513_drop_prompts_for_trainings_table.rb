class DropPromptsForTrainingsTable < ActiveRecord::Migration[8.0]
  def change
	drop_table :prompt_for_trainings
  end
end
