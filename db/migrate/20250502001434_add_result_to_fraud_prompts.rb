class AddResultToFraudPrompts < ActiveRecord::Migration[8.0]
  def change
    add_column :fraud_prompts, :result, :text
  end
end
