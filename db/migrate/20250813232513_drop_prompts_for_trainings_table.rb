class DropPromptsForTrainingsTable < ActiveRecord::Migration[8.0]
  def change
	if table_exists?(:prompt_for_trainings)
		drop_table :prompt_for_trainings
    else
		puts "Table prompt_for_trainings does not exist"
    end
  end
end
