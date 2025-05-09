class RenameFraudTypeToCategoryInFraudPrompts < ActiveRecord::Migration[8.0]
  def change
	rename_column :fraud_prompts, :fraud_type, :category
  end
end
