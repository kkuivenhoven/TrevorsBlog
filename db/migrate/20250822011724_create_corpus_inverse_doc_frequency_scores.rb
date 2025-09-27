class CreateCorpusInverseDocFrequencyScores < ActiveRecord::Migration[8.0]
  def change
    create_table :corpus_inverse_doc_frequency_scores do |t|
      t.references :word, null: false, foreign_key: true
      t.references :prompt, null: false, foreign_key: true
      t.decimal :idf_value

      t.timestamps
    end
  end
end
