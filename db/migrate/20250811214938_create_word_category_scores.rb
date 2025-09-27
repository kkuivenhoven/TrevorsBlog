class CreateWordCategoryScores < ActiveRecord::Migration[8.0]
  def change
    create_table :word_category_scores do |t|
      t.references :word, null: false, foreign_key: true
      t.integer :prompt_id
      t.decimal :tfidf_score
      t.decimal :tfidf_score_global

      t.timestamps
    end
  end
end
