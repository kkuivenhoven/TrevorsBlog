class CreateWordTermFrequencyScores < ActiveRecord::Migration[8.0]
  def change
    create_table :word_term_frequency_scores do |t|
      t.references :word, null: false, foreign_key: true
      t.references :prompt_for_training, null: false, foreign_key: true
      t.decimal :tf_value

      t.timestamps
    end
  end
end
