class CreateFraudPrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :fraud_prompts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :fraud_type
      t.text :user_input

      t.timestamps
    end
  end
end
