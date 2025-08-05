class AddPromptIdToFraudPrompts < ActiveRecord::Migration[8.0]
  def change
    add_reference :fraud_prompts, :prompt, null: true, foreign_key: true
  end
end
