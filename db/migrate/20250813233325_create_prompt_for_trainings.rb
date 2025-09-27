class CreatePromptForTrainings < ActiveRecord::Migration[8.0]
  def change
    create_table :prompt_for_trainings do |t|
      t.references :prompt, null: false, foreign_key: true
      t.text :prompt_text

      t.timestamps
    end
  end
end
