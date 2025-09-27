class AddTfIdfValueToWordTermFrequencyScores < ActiveRecord::Migration[8.0]
  def change
    add_column :word_term_frequency_scores, :TfIdfValue, :float
  end
end
